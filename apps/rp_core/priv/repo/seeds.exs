require Logger

import Ecto.Query

alias RpCore.{ Repo }
alias RpCore.Model.{ Role, User, Company }

# Cleanup

Repo.delete_all(Role)
Repo.delete_all(User)
Repo.delete_all(Company)

# Create Roles

[
  %{name: "admin"},
  %{name: "member"}
] |> Enum.map(fn param ->
  %Role{}
  |> Role.changeset(param)
  |> Repo.insert!
end)

# Create Users

role = Repo.one! from r in Role,
  where: r.name == "admin"

params_admin = %{
  first_name: "John",
  last_name: "Doe"
}

role
|> Ecto.build_assoc(:users)
|> User.changeset(params_admin)
|> Repo.insert!

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

# Total

Logger.warn "Seed Roles: #{ Repo.aggregate(Role, :count, :id) }"
Logger.warn "Seed Users: #{ Repo.aggregate(User, :count, :id) }"
Logger.warn "Seed Company: #{ Repo.aggregate(Company, :count, :id) }"