defmodule JotterWeb.Resolvers.Users do
  alias Jotter.{User, Repo}

  def get_users(_, _) do
    {:ok, User |> Repo.all()}
  end

  def create_user(%{} = user, _) do
    with {:ok, _} = new_user <- %User{} |> User.changeset(user) |> Repo.insert() do
      new_user
    else
      {:error, _} -> {:error, "Can not add user"}
    end
  end

  def delete_user(%{login: login, password: password}, _) do
    with %User{login: ^login, password: ^password} = user <- Repo.get_by(User, [login: login, password: password]),
    {:ok, user} <- Repo.delete(user) do
      {:ok, user}
    else
      {:error, _} -> {:error, "User not deleted"}
      nil         -> {:error, "User not found"}
    end
  end

  def edit_user(%{login: login, password: password} = user, _) do
    with %User{login: ^login, password: ^password} = user_for_change <- Repo.get_by(User, [login: login, password: password]),
    %{valid?: true} = changeset_user <- User.changeset(user_for_change, user),
    {:ok, user} <- Repo.update(changeset_user) do
      {:ok, user}
    else
      nil              -> {:error, "User not found"}
      %{valid?: false} -> {:error, "Change data not valid. User not edited"}
      {:error, _}      -> {:error, "User not edited"}
    end
  end

  def change_login_pass(%{origin_login: origin_login, origin_password: origin_password} = user, _) do
    with %User{login: ^origin_login, password: ^origin_password} = user_for_change <- Repo.get_by(User, [login: origin_login, password: origin_password]),
    %{valid?: true} = changeset_user <- User.changeset(user_for_change, user),
    {:ok, user} <- Repo.update(changeset_user) do
      {:ok, user}
    else
      nil              -> {:error, "User not found"}
      %{valid?: false} -> {:error, "Change data not valid. User not edited"}
      {:error, _}      -> {:error, "User not edited"}
    end
  end

  def check_auth_user(%{login: login, password: password}, _) do
    with %User{password: ^password} = user <- Repo.get_by(User, login: login) do
      {:ok, user}
    else
      _ -> {:error, "Login or password do not match"}
    end
  end

  # def search_user(%{} = user) do

  # end
end
