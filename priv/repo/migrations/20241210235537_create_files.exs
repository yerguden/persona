defmodule Persona.Repo.Migrations.CreateFiles do
  use Ecto.Migration

  def change do
    create table(:files, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :size, :integer
      add :uploaded_at, :naive_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
