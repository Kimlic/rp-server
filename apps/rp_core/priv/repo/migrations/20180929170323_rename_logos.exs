defmodule RpCore.Repo.Migrations.RenameLogos do
  use Ecto.Migration

  def change do
    rename table(:logos, prefix: "rp_core"), to: table(:logos_companys, prefix: "rp_core")
  end
end
