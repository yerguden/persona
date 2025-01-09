defmodule Persona.FileUploadTest do
  use Persona.DataCase

  alias Persona.FileUpload

  describe "files" do
    alias Persona.FileUpload.File

    import Persona.FileUploadFixtures

    @invalid_attrs %{size: nil, title: nil, uploaded_at: nil}

    test "list_files/0 returns all files" do
      file = file_fixture()
      assert FileUpload.list_files() == [file]
    end

    test "get_file!/1 returns the file with given id" do
      file = file_fixture()
      assert FileUpload.get_file!(file.id) == file
    end

    test "create_file/1 with valid data creates a file" do
      valid_attrs = %{size: 42, title: "some title", uploaded_at: ~N[2024-12-09 23:55:00]}

      assert {:ok, %File{} = file} = FileUpload.create_file(valid_attrs)
      assert file.size == 42
      assert file.title == "some title"
      assert file.uploaded_at == ~N[2024-12-09 23:55:00]
    end

    test "create_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FileUpload.create_file(@invalid_attrs)
    end

    test "update_file/2 with valid data updates the file" do
      file = file_fixture()

      update_attrs = %{
        size: 43,
        title: "some updated title",
        uploaded_at: ~N[2024-12-10 23:55:00]
      }

      assert {:ok, %File{} = file} = FileUpload.update_file(file, update_attrs)
      assert file.size == 43
      assert file.title == "some updated title"
      assert file.uploaded_at == ~N[2024-12-10 23:55:00]
    end

    test "update_file/2 with invalid data returns error changeset" do
      file = file_fixture()
      assert {:error, %Ecto.Changeset{}} = FileUpload.update_file(file, @invalid_attrs)
      assert file == FileUpload.get_file!(file.id)
    end

    test "delete_file/1 deletes the file" do
      file = file_fixture()
      assert {:ok, %File{}} = FileUpload.delete_file(file)
      assert_raise Ecto.NoResultsError, fn -> FileUpload.get_file!(file.id) end
    end

    test "change_file/1 returns a file changeset" do
      file = file_fixture()
      assert %Ecto.Changeset{} = FileUpload.change_file(file)
    end
  end
end
