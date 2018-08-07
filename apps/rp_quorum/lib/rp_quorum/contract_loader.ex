defmodule RpQuorum.ContractLoader do
  @moduledoc false

  alias RpQuorum.ABI

  @abi_dir "priv/abi/"

  ##### Public #####

  @spec hash_data(atom, binary, list) :: binary
  def hash_data(contract_module, function, params) do
    contract_module
    |> load_abi()
    |> ABI.parse_specification()
    |> Enum.find(&(&1.function == function))
    |> ABI.encode(params)
    |> Base.encode16(case: :lower)
    |> add_prefix("0x")
  end

  ##### Private #####

  @spec load_abi(atom) :: [map]
  defp load_abi(contract_module) do
    contract_module
    |> contract_path()
    |> File.read!()
    |> Jason.decode!()
  end

  @spec contract_path(atom) :: binary 
  defp contract_path(contract_module) do
    abi_file = contract_module
    |> apply(:abi_file, [])
    
    Application.app_dir(:rp_quorum, @abi_dir <> abi_file)
  end
  defp contract_path(_), do: throw "Invalid contract"
  
  @spec add_prefix(binary, binary) :: binary
  defp add_prefix(string, prefix), do: prefix <> string
end