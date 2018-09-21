defmodule RpDashboardWeb.Resolvers.CompanyResolver do
  
  def company_details(_parent, _args, _resolution) do
    RpCore.company()
  end
end