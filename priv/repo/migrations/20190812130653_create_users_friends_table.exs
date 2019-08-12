defmodule Jotter.Repo.Migrations.CreateUsersFriendsTable do
  use Ecto.Migration

  def change do
    create table(:users_friends) do
      add :user_id, references(:users)
      add :friend_id, references(:users)
      add :status, :string
    end

    # так как у юзера друзья уникальные
    create unique_index(:users_friends, [:user_id, :friend_id])
  end

end
