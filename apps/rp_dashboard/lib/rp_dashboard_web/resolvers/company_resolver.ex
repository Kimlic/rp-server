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
    RpCore.company_update(params[:id], params[:company])

    {:ok, out}
  end

  def logo(_, _, _) do
    {:ok, url} = RpCore.logo_url()
    {:ok, %{url: url}}
  end

  def logo_update(params, _info) do
    {:ok, url} = RpCore.logo_update(params[:company_id], params[:file])
    {:ok, %{url: url}}
  end
end