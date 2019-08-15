defmodule Jotter.User.Friendship do
  use Ecto.Schema
  alias Jotter.{Repo, User}

  schema "users_friendship" do
    # field :user_id, :integer
    # field :friend_id, :integer
    field :status, :string

    # belongs_to :user, User
    belongs_to :user, User, foreign_key: :user_id
    belongs_to :friend, User, foreign_key: :friend_id
    # belongs_to :father, User, [foreign_key: :father_id]
    # belongs_to :mother, User, [foreign_key: :mother_id]
  end
end
