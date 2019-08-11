defmodule Jotter.User do
  use Ecto.Schema
  require Ecto.Query # позовём эту штуку чтобы можно было выполнять её макросы
  alias Ecto.Changeset

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
    has_one :avatar, Jotter.User.Avatar
    has_many :posts, Jotter.User.Post
    has_many :pictures, Jotter.User.Picture
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
    with %Jotter.User{password: ^password} <- Jotter.Repo.get_by(Jotter.User, login: login) do
      {:ok}
    else
      _ -> {:error, "login or password do not match"}
    end
  end

  # запрашиваем первую запись из базы
  def get_first_record do
    Jotter.Repo.one(Ecto.Query.from u in __MODULE__, order_by: [asc: u.id], limit: 1)
  end

  # для последней записи, как обычно записывается (не развёрнуто)
  def get_last_record do
    __MODULE__ # зовём модуль
    |> Ecto.Query.last() # последняя запись
    |> Jotter.Repo.one() # обращение к репе
  end
end
