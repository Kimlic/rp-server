defmodule RpDashboardWeb.Resolvers.AttestatorResolver do

  def attestators(_parent, _args, _resolution), do: {:ok, RpCore.attestators()}
end