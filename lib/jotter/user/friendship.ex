defmodule Jotter.User.Friendship do
  use Ecto.Schema

  require Ecto.Query # позовём эту штуку чтобы можно было выполнять её макросы

  alias Ecto.Changeset
  alias Jotter.{Repo, User}

  schema "users_friendship" do
    field :status, :string

    belongs_to :user, User, foreign_key: :user_id
    belongs_to :friend, User, foreign_key: :friend_id
  end

    # Делаем запрос на добавление в друзья
  def send_friend_request(user_id, friend_id) when user_id != friend_id do
    with %User{id: ^user_id} = user <- Repo.get(User, user_id),
    %User{id: ^friend_id} <- Repo.get(User, friend_id) do
      user
      |> Ecto.build_assoc(:request_users, friend_id: friend_id)
      |> Repo.insert()
    else
      nil -> {:error, "User id #{user_id} or friend id #{friend_id} not found"}
    end
  end

  # Узнаём кто мне отправил запрос в друзья
  def who_friend_request_me(user_id) do
    with %User{id: ^user_id} = user <- Repo.get(User, user_id) do
      user
      |> Repo.preload(:who_request_me)
    else
      nil -> {:error, "User id #{user_id} not found"}
    end
  end

  # Принимаем запрос в друзья и добавляем строку об ответной дружбе за одну транзакцию с проверкой
  def accept_friend_request(user_id, friend_id) when user_id != friend_id do
    with %User{id: ^user_id} = user <- Repo.get(User, user_id),
    %User{id: ^friend_id} = friend <- Repo.get(User, friend_id),
    {:ok, _} <- add_friend(user, friend) do
      {:ok}
    else
      nil -> {:error, "User id #{user_id} or friend id #{friend_id} not found"}
      {:error, _} -> {:error, "Can not add friendship"}
    end
  end

  defp add_friend(user, friend) do
    Repo.transaction(fn ->
      User.Friendship
      |> Ecto.Query.where(user_id: ^user.id, friend_id: ^friend.id, status: "request")
      |> Repo.one!()
      |> Ecto.Changeset.change(status: "friend") # |> IO.inspect()
      |> Repo.update!()

      %User{id: friend.id}
      |> Ecto.build_assoc(:request_users, friend_id: user.id, status: "friend")
      |> Repo.insert!()
    end)
  end

  # Отклоняем запрос в друзья и удалаем запрос из базы дружбы
  def reject_frend_request(user_id, friend_id) when user_id != friend_id do
    with %User{id: ^user_id} <- Repo.get(User, user_id),
    %User{id: ^friend_id} <- Repo.get(User, friend_id) do
      Ecto.Query.from(u in User.Friendship, where: [user_id: ^user_id, friend_id: ^friend_id, status: "request"])
      |> Repo.delete_all()
    else
      nil -> {:error, "User id #{user_id} or friend id #{friend_id} not found"}
    end
  end

  # Проверяем кто наши друзья
  def who_my_friends(user_id) do
    with %User{id: ^user_id} = user <- Repo.get(User, user_id) do
      user
      |> Repo.preload(:my_friends)
    else
      nil -> {:error, "User id #{user_id} not found"}
    end
  end

  # Удаляем из друзей друг друга за одну транзакцию
  def delete_from_friends(user_id, friend_id) when user_id != friend_id do
    with %User{id: ^user_id} <- Repo.get(User, user_id),
    %User{id: ^friend_id} <- Repo.get(User, friend_id) do
      Repo.transaction(fn ->
        Ecto.Query.from(u in User.Friendship, where: [user_id: ^user_id, friend_id: ^friend_id, status: "friend"],
        or_where: [user_id: ^friend_id, friend_id: ^user_id, status: "friend"])
        |> Repo.delete_all()
      end)
    else
      nil -> {:error, "User id #{user_id} or friend id #{friend_id} not found"}
    end
  end

  # Просмотр кому я отправил запрос на добавление в друзья
  def my_requests(user_id) do
    with %User{id: ^user_id} = user <- Repo.get(User, user_id) do
      user
      |> Repo.preload(:request_users)
    else
      nil -> {:error, "User id #{user_id} not found"}
    end
  end
end
