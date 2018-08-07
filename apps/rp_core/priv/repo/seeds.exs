# import Logger
# import Ecto.Query

# alias RpCore.{ Repo, PingPong }

# # # Cleanup

# Repo.delete_all(PingPong)

# # Create

# %PingPong{}
# |> PingPong.changeset()
# |> Repo.insert

# # Total

# Logger.warn "Seed PingPong: #{ Repo.aggregate(PingPong, :count, :id) }"