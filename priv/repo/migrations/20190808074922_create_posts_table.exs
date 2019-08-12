defmodule Jotter.Repo.Migrations.CreatePostsTable do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :text, :string
      add :user_id, references(:users)
    end

  end
end
