defmodule Jotter.User.Picture do

  use Ecto.Schema
  alias Jotter.{Repo, User}

  schema "pictures" do
    field :description, :string
    field :image_url, :string

    belongs_to :user, Jotter.User
  end

  def add_picture(user_id, image_link, image_description) do
    %User{id: user_id}
    |> Ecto.build_assoc(:pictures, %{image_url: image_link, description: image_description})
    |> Repo.insert()
  end
end
