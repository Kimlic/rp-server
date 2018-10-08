defmodule RpCore.Server.MediaServer do
  @moduledoc false

  use GenServer

  alias RpCore.Server.MediaRegistry
  alias RpCore.Model.{Document, Photo}
  alias RpCore.Media.Upload
  alias RpCore.Mapper

  @max_check_polls 12 * 24
  @poll_time 5 * 60 * 1_000
  @timeout 180_000

  ##### Public #####

  def start_link(_args_init, args) do
    name = args[:session_tag]
    |> via

    GenServer.start_link(__MODULE__, args, name: name)
  end

  @spec push_photo(binary, binary, binary, binary) :: {:ok, :created} | {:error, binary}
  def push_photo(session_tag, media_type, file, hash) do
    args = [
      media_type: media_type, 
      file: file, 
      hash: hash
    ]

    via(session_tag)
    |> GenServer.call({:push_photo, args}, @timeout)
  end

  @spec verification_info(binary) :: {:ok, map} | {:ok, nil}
  def verification_info(session_tag) do
    via(session_tag)
    |> GenServer.call(:verification_info)
  end

  ##### gen_server #####


  def whereis(name: name), do: MediaRegistry.whereis_name({:media_server, name})

  @impl true
  def init(user_address: user_address, doc_type_str: doc_type_str, session_tag: session_tag, first_name: first_name, last_name: last_name, device: device, udid: udid, country: country) do
    # vendors = RpAttestation.vendors()
    # IO.inspect "VENDORS: #{inspect vendors}"
    vendors = []
    veriff_doc = Mapper.Veriff.document_quorum_to_veriff(doc_type_str)

    # Get config
    {:ok, config} = RpKimcore.config()
    
    # Create provisioning
    {:ok, provisioning_contract_address} = config.context_contract
    |> create_provisioning(user_address, doc_type_str, session_tag)
    
    # Check verification
    case get_verification_info(provisioning_contract_address) do
      {:ok, :verified, verification_info} -> 
        {:ok, %Document{} = document} = Upload.create_document(user_address, doc_type_str, session_tag, first_name, last_name, country)

        state = %{
          document: document,
          photos: [],
          vendors: vendors,
          session_id: nil, 
          verification_info: verification_info,
          contracts: %{
            provisioning_contract_address: provisioning_contract_address,
            verification_contract_address: nil
          }
        }
        {:ok, state}

      {:ok, :unverified} ->
        ap_address = Enum.fetch!(config.attestation_parties, 0).address
        {:ok, verification_contract_address} = create_verification(config.context_contract, user_address, ap_address, doc_type_str, session_tag)

        case RpAttestation.session_create(first_name, last_name, veriff_doc, verification_contract_address, device, udid) do
          {:error, reason} -> {:error, reason}
          {:ok, session_id} ->
            {:ok, %Document{} = document} = Upload.create_document(user_address, doc_type_str, session_tag, first_name, last_name, country)
            
            check_verification_attempt(@max_check_polls)

            state = %{
              document: document, 
              photos: [], 
              vendors: vendors,
              session_id: session_id, 
              verification_info: nil,
              contracts: %{
                provisioning_contract_address: provisioning_contract_address,
                verification_contract_address: verification_contract_address
              }
            }
            {:ok, state}
        end
      err -> throw err
    end

    # {:error, method, tx} -> {:stop, "Unable to start media server: #{inspect method}, #{inspect tx}"}
    # {:error, reason} -> {:stop, "Unable to start media server: #{inspect reason}"}  
  end
  def init(args), do: {:error, args}

  # def handle_cast({:something, 1}, state) do
  #   IO.puts "This executes first"
  #   {:stop, "This is my reason for stopping", state}
  # end

  # def terminate(reason, state)
  #   IO.puts "Then this executes"
  # end

  @impl true
  def handle_call(:verification_info, _from, state), do: {:reply, {:ok, state[:verification_info]}, state}
  def handle_call({:push_photo, media_type: media_type, file: file, hash: hash}, _from, %{photos: photos, document: document, session_id: session_id, verification_info: verification_info} = state) do
    with {:ok, photo} <- upload_photo(document.id, media_type, file, hash) do
      if is_nil(verification_info) do
        media_type_str = Mapper.Veriff.photo_atom_to_veriff(media_type)
        :ok = RpAttestation.photo_upload(session_id, document.country, media_type_str, file)
      end

      new_photos = photos ++ [photo]
      new_state = %{state | photos: new_photos}

      {:reply, {:ok, :created}, new_state}
    else
      {:error, reason} -> {:reply, {:error, reason}, state}
    end
  end
  def handle_call(message, _from, state), do: {:reply, {:error, message}, state}

  @impl true
  def handle_info({:check_verification_attempt, attempt}, %{document: document, session_id: session_id, contracts: %{provisioning_contract_address: provisioning_contract_address}} = state) do
    if attempt < 1 do
      RpQuorum.tokens_unlock_at(provisioning_contract_address)
      RpQuorum.withdraw(provisioning_contract_address)

      Process.exit(self(), :normal)
    else
      case get_verification_info(provisioning_contract_address) do
        {:ok, :verified, verification_info} -> 
          IO.puts "VERIFICATION INFO: #{inspect verification_info}"
          with {:ok, info} <- RpAttestation.verification_info(session_id) do
            IO.puts "AP INFO: #{inspect info}"
            Document.verified_info(document, info)
          else
            {:error, :not_found} -> 
              IO.puts "AP INFO NOT FOUND"
              throw "Unable to fetch document: #{inspect document}, session id: #{inspect session_id}"
          end
        
          {:noreply, %{state | verification_info: verification_info}}

        {:ok, :unverified} -> 
          check_verification_attempt(attempt - 1)
          {:noreply, state}
  
        err -> throw "Unhandled exception: #{inspect err}"
      end
    end
  end
  def handle_info(args, state), do: throw "Unhandled info: #{inspect args}   STATE: #{inspect state}"

  ##### Private #####

  @spec via(binary) :: tuple
  defp via(name), do: {:via, MediaRegistry, {:media_server, name}}

  @spec create_provisioning(binary, binary, binary, binary) :: {:ok, binary}
  defp create_provisioning(context_contract_address, user_address, doc_type, session_tag) do
    {:ok, provisioning_contract_factory_address} = context_contract_address |> RpQuorum.get_provisioning_contract_factory
    {:ok, _method, _tx_hash} = provisioning_contract_factory_address |> RpQuorum.create_provisioning_contract(user_address, doc_type, session_tag)
    provisioning_contract_factory_address |> RpQuorum.get_provisioning_contract(session_tag)
  end

  @spec create_verification(binary, binary, binary, binary, binary) :: {:ok, binary}
  defp create_verification(context_contract_address, user_address, ap_address, doc_type, session_tag) do
    {:ok, verification_contract_factory_address} = context_contract_address |> RpQuorum.get_verification_contract_factory
    {:ok, _method, _tx_hash} = verification_contract_factory_address |> RpQuorum.create_base_verification_contract(user_address, ap_address, doc_type, session_tag)
    verification_contract_factory_address |> RpQuorum.get_verification_contract(session_tag)
  end

  @spec get_verification_info(binary) :: {:ok, atom, map} | {:ok, atom}
  defp get_verification_info(provisioning_contract_address) do
    IO.puts "AAA: #{inspect provisioning_contract_address}"
    case provisioning_contract_address |> RpQuorum.is_verification_finished do
      {:ok, :unverified} -> {:ok, :unverified}

      {:ok, :verified} ->
        IO.puts "BBB: verified"
        :ok = provisioning_contract_address |> RpQuorum.finalize_provisioning
        IO.puts "CCC: finalize_provisioning"
        case provisioning_contract_address |> RpQuorum.get_verification_info do
          {:ok, :unverified} -> 
            IO.puts "EEE: unverified"
            {:ok, :unverified}

          {:ok, verification_info} -> 
            IO.puts "DDD: #{inspect verification_info}"
            {:ok, :verified, verification_info}
        end
    end

    # {:ok, :verified, verification_info}

    # with {:ok, :verified} <- provisioning_contract_address |> RpQuorum.is_verification_finished,
    #   :ok <- provisioning_contract_address |> RpQuorum.finalize_provisioning,
    #   {:ok, verification_info} <- provisioning_contract_address |> RpQuorum.get_verification_info do
    #     {:ok, :verified, verification_info}
    # else
    #   {:ok, :unverified} -> {:ok, :unverified}
    # end
  end

  @spec upload_photo(binary, atom, binary, binary) :: {:ok, Photo.t()} | {:error, binary}
  defp upload_photo(document_id, media_type, file, hash) do
    media_type_str = Mapper.Veriff.photo_atom_to_veriff(media_type)

    with {:ok, %Photo{} = photo} <- Upload.create_photo(document_id, media_type_str, file, hash) do
      {:ok, photo}   
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @spec check_verification_attempt(non_neg_integer) :: pid
  defp check_verification_attempt(attempt) do
    attrs = {:check_verification_attempt, attempt}

    self()
    |> Process.send_after(attrs, @poll_time)
  end
end