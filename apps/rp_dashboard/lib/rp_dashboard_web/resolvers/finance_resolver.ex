defmodule RpDashboardWeb.Resolvers.FinanceResolver do

  def balance(_, _, _) do
    {:ok, value} = RpQuorum.balance()
    {:ok, %{value: value}}
  end
end