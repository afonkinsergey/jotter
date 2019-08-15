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

  # запрашиваем первую запись из базы
  def get_first_record do
    Repo.one(Ecto.Query.from u in __MODULE__, order_by: [asc: u.id], limit: 1)
  end

  # для последней записи, как обычно записывается (не развёрнуто)
  def get_last_record do
    __MODULE__ # зовём модуль
    |> Ecto.Query.last() # последняя запись
    |> Repo.one() # обращение к репе
  end

  def send_friend_request(user_id, friend_id) when user_id != friend_id do # правильно ли так делать?
    with %User{id: ^user_id} = user <- Repo.get(User, user_id),
    %User{id: ^friend_id} <- Repo.get(User, friend_id) do
      user
      |> Ecto.build_assoc(:request_users, friend_id: friend_id)
      |> Repo.insert()
    else
      :nil -> {:error, "User id not found"}
    end
  end

  def who_request_me(user_id) do
    User
    |> Repo.get(user_id)
    |> Repo.preload(:who_request_me)
  end

  def accept_user_request(user_id, friend_id) do
    User.Friendship
    |> Ecto.Query.where(user_id: ^user_id, friend_id: ^friend_id) #|> IO.inspect()
    |> Repo.one()
    |> Ecto.Changeset.change() |> IO.inspect()
    |> Ecto.Changeset.put_change(:status, "friend")
    |> Repo.update()
  end

  def reject_user_request(user_id, friend_id) do
    User.Friendship
    |> Ecto.Query.where(user_id: ^user_id, friend_id: ^friend_id) #|> IO.inspect()
    |> Repo.one()
    |> Ecto.Changeset.change()
    |> Repo.delete()
  end
end
