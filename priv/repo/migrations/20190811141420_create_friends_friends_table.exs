defmodule Jotter.Repo.Migrations.CreateFriendsFriendsTable do
  use Ecto.Migration

  def change do
    create table(:friends_friends) do
      add :user_id, references(:users)
    end

    # так как у юзера друзья уникальные
    create unique_index(:friends_friends, :user_id)
  end

end
