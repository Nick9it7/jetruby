defmodule Jetruby.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :data, :jsonb
      add :name, :string, null: false
      add :repo_id, :integer, null: false
      add :stars, :integer
    end

    create unique_index(:repositories, [:repo_id])
    create unique_index(:repositories, [:name])
    create index(:repositories, ["stars DESC NULLS LAST"])
  end
end
