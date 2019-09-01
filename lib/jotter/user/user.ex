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
      # можно так записать (params, ~w[login password .....]a)

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

  def get_user!(id), do: Repo.get!(User, id)

  # создаём нового юзера
  def create_user(%{} = params) do
    with {:ok, _} = new_user <- %User{} |> User.changeset(params) |> Repo.insert() do
      new_user
    else
      _ -> {:error, "Can not create user"}
    end
  end

  def create_user(_), do: {:error, "Can not create user"}

  # Список всех юзеров
  def all_users do
    Repo.all(User)
  end

  # обновляем какие-либо параметры юзера
  def update_user(%{login: login, password: password} = params) do
    with  user when not is_nil(user)       <- Repo.get_by(User, login: login, password: password),
          %{valid?: true} = changeset_user <- User.changeset(user, params),
          {:ok, updated_user}              <- Repo.update(changeset_user) do
      {:ok, updated_user}
    else
      _ -> {:error, "Can not update user"}
    end
  end

  def update_user(_), do: {:error, "Can not update user"}

  # сверяем переданную пару логин-пароль
  def check_auth_user(%{login: login, password: password}) do
    with user when not is_nil(user) <- Repo.get_by(User, login: login, password: password) do
      {:ok, user}
    else
      _ -> {:error, "Login or password do not match"}
    end
  end

  def check_auth(_), do: {:error, "Login or password do not match"}

  # удаляем юзера
  # TODO: если удаляем юзера, то нужно удалить дружбу, посты, картинки, без этого ошибка ассоциации
  def delete_user(%{login: login, password: password}) do
    with  user when not is_nil(user) <- Repo.get_by(User, login: login, password: password),
          {:ok, user}                <- Repo.delete(user) do
      {:ok, user}
    else
      _ -> {:error, "User not deleted"}
    end
  end

  def delete_user(_), do: {:error, "User not deleted"}

  # изменяем логин или пароль юзера
  def change_login_pass(%{origin_login: origin_login, origin_password: origin_password} = params) do
    with  user when not is_nil(user)       <- Repo.get_by(User, login: origin_login, password: origin_password),
          %{valid?: true} = changeset_user <- User.changeset(user, params),
          {:ok, updated_user}              <- Repo.update(changeset_user) do
      {:ok, updated_user}
    else
      _ -> {:error, "Can not update user"}
    end
  end

  def change_login_pass(_), do: {:error, "Can not update user"}

  # Ищем юзера по параметрам
  def search_user(%{} = params) do
    with  [_ | _] = params_list <- Map.to_list(params),
          [_ | _] = user_list         <- Ecto.Query.where(User, ^params_list) |> Repo.all() do
      {:ok, user_list}
    else
      _ -> {:error, "User not found"}
    end
  end
end
