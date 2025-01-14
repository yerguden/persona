defmodule Persona.FileUpload.File do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "files" do
    field :size, :integer
    field :title, :string
    field :s3_key, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(file, attrs) do
    file
    |> cast(attrs, [:title, :size, :s3_key])
    |> validate_required([:title, :size, :s3_key])
  end
end
