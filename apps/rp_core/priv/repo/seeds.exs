require Logger

alias RpCore.{ Repo }
alias RpCore.Model.Company

# Cleanup

Repo.delete_all(Company)

# Create

params = %{
  name: "Kimlic Relying Party",
  email: "dmytro@kimlic.com",
  website: "http://www.kimlic.com",
  phone: "+380997762791",
  address: "Konovaltsa 44B, 201, Kyiv 01133, Ukraine",
  details: "Demo relying party. For test purposes only."
}

%Company{}
|> Company.changeset(params)
|> Repo.insert

# Total

Logger.warn "Seed Company: #{ Repo.aggregate(Company, :count, :id) }"