defmodule Jotter.User do
  use Ecto.Schema
  require Ecto.Query # позовём эту штуку чтобы можно было выполнять её макросы
  alias Ecto.Changeset
  alias Jotter.{Repo, User}

  schema "users" do
    field :login, :string
    field :password, :string
    field :email, :string
    field :name, :string
    field :surname, :string
    field :age, :integer
    field :sex, :string
    field :city, :string

    # как бы ссылка к .Avatar где у нас есть belongs_to
    has_one :avatar, User.Avatar
    has_many :posts, User.Post
    has_many :pictures, User.Picture
    # has_many :users_friendship, User.Friendship #, join_keys: [user_id: :id, friend_id: :id]
    has_many :request_users, User.Friendship, foreign_key: :user_id, where: [status: "request"]
    has_many :who_request_me, User.Friendship, foreign_key: :friend_id, where: [status: "request"]
    has_many :my_friends, User.Friendship, foreign_key: :user_id, where: [status: "friend"]
  end

  # ниже специальная функция, которая делает проверку перед тем как передать запись в бд
  def changeset(user, params \\ %{}) do
    user
    |> Changeset.cast(params, [
      :login,
      :password,
      :email,
      :name,
      :surname,
      :age,
      :sex,
      :city
      ])

    # определяем обязательное заполнение полей
    |> Changeset.validate_required([:login, :password, :email, :name, :surname])

    # проверяем на минимальную длину логина 3 символа
    |> Changeset.validate_length(:login, min: 3)

    # проверяем валидность имейла
    |> Changeset.validate_format(:email, ~r/@/)

    # проверка на валидные символы логина из тз: 0-9, a-z, A-Z
    # наверное это как-то можно объеденить с валидацией емайла
    |> Changeset.validate_format(:login, ~r/^[A-Za-z0-9]/)

    # нужна проверка на уникальность логина
    |> Changeset.unique_constraint(:login)
  end

  # сверяем переданную пару логин-пароль
  def check_auth(login, password) do
    with %User{password: ^password} <- Repo.get_by(User, login: login) do
      {:ok}
    else
      _ -> {:error, "login or password do not match"}
    end
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
    with %User{id: ^user_id} <- Repo.get(User, user_id),
    %User{id: ^friend_id} <- Repo.get(User, friend_id),
    {:ok, _} <- add_friend(user_id, friend_id) do
      {:ok}
    else
      nil -> {:error, "User id #{user_id} or friend id #{friend_id} not found"}
      {:error, _} -> {:error, "Can not add friendship"}
    end
  end

  defp add_friend(user_id, friend_id) do
    Repo.transaction(fn ->
      User.Friendship
      |> Ecto.Query.where(user_id: ^user_id, friend_id: ^friend_id, status: "request")
      |> Repo.one!()
      |> Ecto.Changeset.change(status: "friend") # |> IO.inspect()
      |> Repo.update!()

      %User{id: friend_id}
      |> Ecto.build_assoc(:request_users, friend_id: user_id, status: "friend")
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
    with %User{id: ^user_id} <- Repo.get(User, user_id) do
      User
      |> Repo.get(user_id)
      |> Repo.preload(:request_users)
    else
      nil -> {:error, "User id #{user_id} not found"}
    end
  end
end

# TODO: 1) сделать отмену запроса со стороны юзера который отправлял запрос. ЭТО РЕАЛИЗОВАНО В ОТКЛОНЕНИИ ЗАПРОСА.
# TODO: 2) просмотр кому я отправил запрос на добавление в друзья. СДЕЛАНО.


  # # Делаем запрос на добавление в друзья с проверкой на ранее добавленный запрос
  # def send_friend_request(user_id, friend_id) when user_id != friend_id do
  #   with %User{id: ^user_id} <- Repo.get(User, user_id),
  #   %User{id: ^friend_id} <- Repo.get(User, friend_id) do

  #     if Repo.get_by(User.Friendship, [user_id: friend_id, friend_id: user_id, status: "request"]) do
  #       {:error, "You have already sent a request"}
  #     else
  #       friend_request(user_id, friend_id)
  #     end

  #   else
  #     nil -> {:error, "User id #{user_id} or friend id #{friend_id} not found"}
  #   end
  # end

  # defp friend_request(user_id, friend_id) do
  #   %User{id: user_id}
  #   |> Ecto.build_assoc(:request_users, friend_id: friend_id)
  #   |> Repo.insert()
  # end
