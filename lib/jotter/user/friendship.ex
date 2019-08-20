defmodule Jotter.User.Friendship do
  use Ecto.Schema
  alias Jotter.User

  schema "users_friendship" do
    field :status, :string

    belongs_to :user, User, foreign_key: :user_id
    belongs_to :friend, User, foreign_key: :friend_id
  end
end
