defmodule Persona.FileUploadFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Persona.FileUpload` context.
  """

  @doc """
  Generate a file.
  """
  def file_fixture(attrs \\ %{}) do
    {:ok, file} =
      attrs
      |> Enum.into(%{
        size: 42,
        title: "some title",
        uploaded_at: ~N[2024-12-09 23:55:00]
      })
      |> Persona.FileUpload.create_file()

    file
  end
end
