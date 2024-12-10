defmodule Persona.FileUpload.File do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "files" do
    field :size, :integer
    field :title, :string
    field :uploaded_at, :naive_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:title, :size, :uploaded_at])
    |> validate_required([:title, :size, :uploaded_at])
  end
end
