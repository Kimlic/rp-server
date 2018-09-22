defmodule RpDashboardWeb.Resolvers.CompanyResolver do
  
  def company(_parent, _args, _resolution), do: RpCore.company()

  def update(params, _info) do
    out = %{
      id: params[:id], 
      name: params[:company][:name], 
      email: params[:company][:email],
      phone: params[:company][:phone],
      address: params[:company][:address],
      website: params[:company][:website],
      details: params[:company][:details]
    }
    RpCore.companyUpdate(params[:id], params[:company])

    {:ok, out}
  end
end