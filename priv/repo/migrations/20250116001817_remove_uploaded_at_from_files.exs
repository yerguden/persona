defmodule Persona.Repo.Migrations.RemoveUploadedAtFromFiles do
  use Ecto.Migration

  def change do
    alter table(:files) do
      remove :uploaded_at
    end
  end
end
