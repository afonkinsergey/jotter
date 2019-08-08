defmodule Jotter.Repo.Migrations.CreatePicturesTable do
  use Ecto.Migration

  def change do
    create table(:pictures) do
      add :description, :string
      add :image_url, :string
      add :user_id, references(:users)
    end
  end
end
