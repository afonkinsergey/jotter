defmodule Jotter.User.Post do

  use Ecto.Schema
  alias Jotter.{Repo, User} # этот алиас сразу к нескольким модулям с одинаковым путём

  schema "posts" do
    field :text, :string

    belongs_to :user, Jotter.User # принадлежит пользователю
    # many_to_many :tags, Backend.User.Tag, join_through: "posts_tags"
  end

  def new_post(user_id, text) do
    %User{id: user_id} # ссылаемся на уже существующего пользователя
    |> Ecto.build_assoc(:posts, %{text: text}) # строим ассоциацию
    |> Repo.insert()
  end
end
