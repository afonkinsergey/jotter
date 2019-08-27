defmodule Jotter.User.Friendship do
  use Ecto.Schema

  require Ecto.Query # позовём эту штуку чтобы можно было выполнять её макросы

  alias Ecto.{Changeset, Query}
  alias Jotter.{Repo, User, User.Friendship}

  schema "users_friendship" do
    field :status, :string

    belongs_to :user, User, foreign_key: :user_id
    belongs_to :friend, User, foreign_key: :friend_id
  end

  # Делаем запрос на добавление в друзья
  def send_friend_request(%{login: login, password: password, friend_login: friend_login}) when login != friend_login do
    with  user when not is_nil(user)     <- Repo.get_by(User, login: login, password: password),
          friend when not is_nil(friend) <- Repo.get_by(User, login: friend_login),
          {:ok, requsted}                <-
          user
          |> Ecto.build_assoc(:request_users, friend_id: friend.id)
          |> Repo.insert(on_conflict: :nothing) do
      {:ok, requsted}
    else
      nil -> {:error, "User #{login} or friend #{friend_login} not found"}
      _   -> {:error, "Friendship is not created"}
    end
  end

  def send_friend_request(%{login: login, password: _password, friend_login: friend_login}) when login == friend_login, do: {:error, "Can not make friendship"}

  # Принимаем запрос в друзья и добавляем строку об ответной дружбе за одну транзакцию с проверкой
  def accept_friend_request(%{login: login, friend_login: friend_login, friend_password: friend_password}) when login != friend_login do
    with  user when not is_nil(user)     <- Repo.get_by(User, login: login),
          friend when not is_nil(friend) <- Repo.get_by(User, login: friend_login, password: friend_password),
          {:ok, accepted}                <- add_friend(user, friend) do
      {:ok, accepted}
    else
      nil -> {:error, "User #{login} or friend #{friend_login} not found"}
      _   -> {:error, "Friendship is not created"}
    end
  end

  def accept_friend_request(%{login: login, friend_login: friend_login, friend_password: _friend_password}) when login == friend_login, do: {:error, "Can not accept friendship"}

  defp add_friend(user, friend) do
    Repo.transaction(fn ->
      User.Friendship
      |> Query.where(user_id: ^user.id, friend_id: ^friend.id, status: "request")
      |> Repo.one!()
      |> Changeset.change(status: "friend") # |> IO.inspect()
      |> Repo.update!()

      %User{id: friend.id}
      |> Ecto.build_assoc(:request_users, friend_id: user.id, status: "friend")
      |> Repo.insert!()
    end)
  end

  # Отклоняем запрос в друзья и удалаем запрос из базы дружбы
  def reject_friend_request(%{login: login, friend_login: friend_login, friend_password: friend_password}) when login != friend_login do
    with  user when not is_nil(user)     <- Repo.get_by(User, login: login),
          friend when not is_nil(friend) <- Repo.get_by(User, login: friend_login, password: friend_password),
          {_, nil}                       <-
          Query.from(u in User.Friendship, where: [user_id: ^user.id, friend_id: ^friend.id, status: "request"])
          |> Repo.delete_all() do
      {:ok}
    else
      nil -> {:error, "User #{login} or friend #{friend_login} not found"}
      _   -> {:error, "Request is not rejected"}
    end
  end

  def reject_friend_request(%{login: login, friend_login: friend_login, friend_password: _friend_password}) when login == friend_login, do: {:error, "Can not reject friendship"}

  # Удаляем из друзей друг друга
  def delete_from_friends(%{login: login, password: password, friend_login: friend_login}) when login != friend_login do
    with  user when not is_nil(user)     <- Repo.get_by(User, login: login, password: password),
          friend when not is_nil(friend) <- Repo.get_by(User, login: friend_login),
          {_, nil}                       <-
          Query.from(u in User.Friendship, where: [user_id: ^user.id, friend_id: ^friend.id, status: "friend"],
          or_where: [user_id: ^friend.id, friend_id: ^user.id, status: "friend"])
          |> Repo.delete_all() do
      {:ok}
    else
      nil -> {:error, "User #{login} or friend #{friend_login} not found"}
      _   -> {:error, "Friendship is not canceled"}
    end
  end

  def delete_from_friends(%{login: login, password: _password, friend_login: friend_login}) when login == friend_login, do: {:error, "Can not cancel friendship"}

  # Узнаём кто мне отправил запрос в друзья
  def who_friend_request_me(%{login: login, password: password}) do
    with user when not is_nil(user) <- Repo.get_by(User, login: login, password: password) do
      Query.from(
      u in User,
      join: f in Friendship, on: [user_id: u.id, friend_id: ^user.id, status: "request"])
    |> Repo.all()
    else
      nil -> {:error, "User #{login} not found"}
      _   -> {:error, "You have not friends requests"}
    end
  end

  def who_friend_request_me(_), do: {:error, "Input data is not valid"}

  # Просмотр кому я отправил запрос на добавление в друзья
  def my_friend_requests(%{login: login, password: password}) do
    with user when not is_nil(user) <- Repo.get_by(User, login: login, password: password) do
      Query.from(
      u in User,
      join: f in Friendship, on: [user_id: ^user.id, friend_id: u.id, status: "request"])
    |> Repo.all()
    else
      nil -> {:error, "User #{login} not found"}
      _   -> {:error, "You did not send friends requests"}
    end
  end

  # Проверяем кто наши друзья
  def who_my_friends(%{login: login, password: password}) do
    with user when not is_nil(user) <- Repo.get_by(User, login: login, password: password) do
      Query.from(
      u in User,
      join: f in Friendship, on: [user_id: ^user.id, friend_id: u.id, status: "friend"])
    |> Repo.all()
    else
      nil -> {:error, "User #{login} not found"}
      _   -> {:error, "You have not a friends"}
    end
  end
end
