defmodule Jotter.User.Avatar do
  use Ecto.Schema
  alias Jotter.{Repo, User}

  schema "avatars" do
    field :nick_name, :string
    field :image_url, :string

    # связь с таблицей юзера
    belongs_to :user, Jotter.User
  end

  # добавление аватары
  # def add_avatar(user_id, avatar_link) do
  #   %User{id: user_id}
  #   |> Ecto.build_assoc(:avatar, %{image_url: avatar_link})
  #   |> Repo.insert()
  # end

  # добавление аватары с проверкой существования юзера
  def add_avatar(user_id, avatar_link) do
    with %User{id: ^user_id} <- Repo.get(User, user_id) do
      %User{id: user_id}
      |> Ecto.build_assoc(:avatar, %{image_url: avatar_link})
      |> Repo.insert()
    else
      :nil -> {:error, "User id not found"}
    end
  end

end
