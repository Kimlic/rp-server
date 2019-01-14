defmodule RpKimcore.DataProvider do
  @moduledoc false

  @pool :kim_pool

  alias RpKimcore.Schema.Config
  
  ##### Public #####

  @spec config() :: {:ok, Config.t()} | {:error, binary()}
  def config do
    kim_config()
    |> get
    |> case do
      {:error, reason} -> 
        IO.puts "ERR: #{inspect reason}"
        {:error, reason}
      {:ok, %{} = res} -> parseConfigRes(res)
    end
  end

  ##### Private #####

  @spec get(binary()) :: {:error, binary()} | {:ok, map()}
  defp get(endpoint) do
    IO.puts "ENDPOINT: #{inspect(kim_endpoint()<>endpoint)}"
    kim_endpoint()
    |> Kernel.<>(endpoint)
    |> RpHttp.get(@pool)
  end

  @spec parseConfigRes(Ecto.Changeset.t()) :: {:ok, Config.t()} | {:error, binary()}
  defp parseConfigRes(res) do
    changeset = res
    |> Map.fetch!("data")
    |> Config.changeset()
        
    case changeset.valid? do
      true -> {:ok, Ecto.Changeset.apply_changes(changeset)}
      false -> pretty_errors(changeset)
    end
  end

  @spec pretty_errors(Ecto.Changeset.t()) :: {:error, binary()}
  defp pretty_errors(changeset) do
    errors = for {_key, {message, _}} <- changeset.errors, do: "#{message}"
    {:error, errors}
  end

  @spec kim_endpoint() :: binary()
  defp kim_endpoint, do: env(:kim_endpoint)

  @spec kim_config() :: binary()
  defp kim_config, do: env(:kim_config)

  @spec env(:kim_config | :kim_endpoint) :: binary()
  defp env(param), do: Application.get_env(:rp_kimcore, param)
end