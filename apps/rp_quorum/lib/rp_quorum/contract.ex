defmodule RpQuorum.Contract do
  @moduledoc false

  defmacro __using__(_) do
      quote do
        alias __MODULE__
        alias RpQuorum.ContractServer
        alias RpQuorum.Contract.{
          KimlicContractsContext, 
          ProvisioningContractFactory, 
          # AccountStorageAdapter,
          ProvisioningContract,
          VerificationContractFactory
        }
      end
  end
end
