defmodule Persona.Repo.Migrations.AddS3KeyToFile do
  use Ecto.Migration

  def change do
    alter table(:files) do
      add :s3_key, :string, null: false
    end
  end
end
