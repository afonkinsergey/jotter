defmodule Jotter.User.Session do
  alias Jotter.{Repo, User}

  def authenticate(args) do
    with %User{} = user <- Repo.get_by(User, login: args.login, password: args.password) do
      {:ok, user}
    else
      _ -> {:error, "Incorrect login credentials"}
    end
  end
end
