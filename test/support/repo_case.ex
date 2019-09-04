defmodule Jotter.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Jotter.Repo

      import Ecto
      import Ecto.Query
      import Jotter.RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Jotter.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Jotter.Repo, {:shared, self()})
    end

    :ok
  end
end
