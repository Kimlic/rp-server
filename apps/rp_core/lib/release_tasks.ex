defmodule RpCore.ReleaseTasks do
    @moduledoc false

    def migrate do
        IO.puts("Starting dependencies...")
        Enum.each([:postgrex, :ecto, :rp_core], &Application.ensure_all_started/1)
    
        IO.puts("Starting repos...")
        Enum.each([RpCore.Repo], & &1.start_link(pool_size: 1))

        IO.puts("Migrating...")
        Enum.each([:rp_core], &run_migrations_for/1)
    
        IO.puts("Success!")
        :init.stop()
    end

    def seeds do
        IO.puts("Starting dependencies...")
        Enum.each([:postgrex, :ecto, :rp_core], &Application.ensure_all_started/1)
    
        IO.puts("Starting repos...")
        Enum.each([RpCore.Repo], & &1.start_link(pool_size: 1))

        IO.puts "Running seeds.."
        Enum.each([RpCore.Repo], &run_seeds_for/1)
    
        IO.puts("Success!")
        :init.stop()
    end

    def run_seeds_for(repo) do
        IO.puts "REPO: #{repo}"
        seed_script = "/rp_server/apps/rp_core/priv/repo/seeds.exs" # seeds_path(repo)
        IO.puts "SCRIPT: #{seed_script}"
        IO.puts "EXISTS: #{File.exists?(seed_script)}"

        if File.exists?(seed_script) do
            Code.eval_file(seed_script)
        end
    end
    
    def priv_dir(app), do: "#{:code.priv_dir(app)}"
    
    defp run_migrations_for(app) do
        IO.puts("Running migrations for #{app}")
        Ecto.Migrator.run(RpCore.Repo, migrations_path(app), :up, all: true)
    end
    
    defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])

    # defp seeds_path(repo), do: priv_path_for(repo, "seeds.exs")

    # defp priv_path_for(repo, filename) do
    #     app = Keyword.get(repo.config, :otp_app)
    #     IO.puts "APP: #{app}"
    #     repo_underscore = repo |> Module.split |> List.last |> Macro.underscore
    #     IO.puts "REPO_UNDERSCORE: #{repo_underscore}"
    #     Path.join([priv_dir(app), repo_underscore, filename])
    # end

    # defp repos, do: Application.get_env(:rp_core, :ecto_repos, [])

    # def get_app, do: Application.get_application(__MODULE__)
end
