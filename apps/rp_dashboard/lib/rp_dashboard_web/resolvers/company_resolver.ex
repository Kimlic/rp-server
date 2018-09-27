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
    case RpCore.logo_url() do
      {:ok, url} -> {:ok, %{url: url}}
      {:error, :not_found} -> {:ok, %{url: nil, errors: 'Not Found'}}
    end
  end

  def logo_update(params, _info) do
    ext = params[:file].filename
    |> Path.extname
    |> String.downcase

    file = case ext do
    ".svg" -> Map.put(params[:file], :content_type, "image/svg+xml")
    _ -> params[:file]
    end

    {:ok, url} = RpCore.logo_update(params[:company_id], file)
    {:ok, %{url: url}}
  end
end