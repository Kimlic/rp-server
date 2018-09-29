require Logger

import Ecto.Query

alias RpCore.{ Repo }
alias RpCore.Uploader.File
alias RpCore.Model.{ 
  Role, 
  User, 
  Company, 
  # Document, 
  Attestator,
  LogosAttestator
}

# Cleanup

# Repo.delete_all(Role)
# Repo.delete_all(User)
Repo.delete_all(Company)
Repo.delete_all(Attestator)

# Create Roles

# [
#   %{name: "admin"},
#   %{name: "member"}
# ] |> Enum.map(fn param ->
#   %Role{}
#   |> Role.changeset(param)
#   |> Repo.insert!
# end)

# Create Users

# role = Repo.one! from r in Role,
#   where: r.name == "admin"

# params_admin = %{
#   first_name: "John",
#   last_name: "Doe"
# }

# role
# |> Ecto.build_assoc(:users)
# |> User.changeset(params_admin)
# |> Repo.insert!

# Create Company

params_company = %{
  name: "Kimlic Relying Party",
  email: "dmytro@kimlic.com",
  website: "http://www.kimlic.com",
  phone: "+380997762791",
  address: "Konovaltsa 44B, 201, Kyiv 01133, Ukraine",
  details: "Demo relying party. For test purposes only."
}

%Company{}
|> Company.changeset(params_company)
|> Repo.insert!

# Create Attestator

{:ok, response} = Ecto.Interval.cast(%{"months" => "0", "days" => "1", "secs" => "0"})
params_attestator = %{
  name: "Veriff",
  cost_per_user: 0.0000145,
  compliance: ["KYC", "AML"],
  response: response,
  rating: 4,
  status: true
}

attestator = %Attestator{}
|> Attestator.changeset(params_attestator)
|> Repo.insert!

{:ok, path} = Path.relative("/apps/rp_core/priv/repo/assets/veriff_logo.jpg")
|> File.store

params_logo_attestator = %{
  file: File.url(path),
  attestator_id: attestator.id
}

%LogosAttestator{}
|> LogosAttestator.changeset(params_logo_attestator)
|> Repo.insert!

# Document

# [
#   %{
#     user_address: "asdfklaskdf9as0dfk09adj9f0jas09fj",
#     session_tag: "as09djf09jsa90fj09adsjf90jas09dfj",
#     type: "passport",
#     first_name: "John",
#     last_name: "Doe",
#     country: "Ukraine"
#   },
#   %{
#     user_address: "asd0fk0-dskf0aks-d0fka0sdf",
#     session_tag: "asd-0fi-0asidf-0ias-0dif-0sdif",
#     type: "id_card",
#     first_name: "John",
#     last_name: "Smith",
#     country: "UK"
#   }
# ] |> Enum.map(fn param ->
#   %Document{}
#   |> Document.changeset(param)
#   |> Repo.insert!
# end)

# Total

Logger.warn "Seed Roles: #{ Repo.aggregate(Role, :count, :id) }"
Logger.warn "Seed Users: #{ Repo.aggregate(User, :count, :id) }"
Logger.warn "Seed Companies: #{ Repo.aggregate(Company, :count, :id) }"
Logger.warn "Seed Attesttors: #{ Repo.aggregate(Attestator, :count, :id) }"
Logger.warn "Seed LogosAttestator: #{ Repo.aggregate(LogosAttestator, :count, :id) }"
# Logger.warn "Seed Documents: #{ Repo.aggregate(Document, :count, :id) }"