defmodule Jotter.Repo.Migrations.CreateUsersFriendshipTable do
  use Ecto.Migration

  def change do
    create table(:users_friendship) do
      add :user_id, references(:users)
      add :friend_id, references(:users)
      add :status, :string, default: "request"
    end

    # так как у юзера друзья уникальные
    create unique_index(:users_friendship, [:user_id, :friend_id])
  end
end
