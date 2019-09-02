defmodule Jotter.User.Session do
  alias Jotter.{Repo, User}

  def authenticate(%{login: login, password: password}) do
    with %User{} = user <- Repo.get_by(User, login: login, password: password) do
      {:ok, user}
    else
      _ -> {:error, "Incorrect login credentials"}
    end
  end

  def authenticate(_), do: {:error, "Incorrect login credentials"}
end
