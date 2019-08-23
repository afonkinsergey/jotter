defmodule JotterWeb.Resolvers.Friends do
  alias Jotter.{User, Repo}

  def send_friend_request(%{user_login: user_login, user_password: user_password, friend_login: friend_login}, _) when user_login != friend_login do
    with %User{login: ^user_login, password: ^user_password} = user <- Repo.get_by(User, [login: user_login, password: user_password]),
    %User{login: ^friend_login} = friend <- Repo.get_by(User, login: friend_login) do
      user
      |> Ecto.build_assoc(:request_users, friend_id: friend.id)
      |> Repo.insert()
    else
      nil -> {:error, "User #{user_login} or friend #{friend_login} not found"}
    end
  end
end
