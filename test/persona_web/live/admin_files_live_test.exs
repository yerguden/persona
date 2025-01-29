defmodule AdminFilesLiveTest do
  use PersonaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Persona.FileUploadFixtures

  @admin_username Application.fetch_env!(:persona, :admin_username)
  @admin_password Application.fetch_env!(:persona, :admin_password)

  def log_in_admin(conn) do
    # Encode Basic Auth credentials
    auth_header = Plug.BasicAuth.encode_basic_auth(@admin_username, @admin_password)

    # Simulate a connection with the Authorization header
    put_req_header(conn, "authorization", auth_header)
  end

  describe "AdminFilesLive" do
    test "renders upload form", %{conn: conn} do
      {:ok, view, _html} = conn |> log_in_admin() |> live("/admin/files")

      assert render(view) =~ "Upload"
    end

    test "shows existing files", %{conn: conn} do
      file = file_fixture()
      {:ok, view, _html} = conn |> log_in_admin() |> live("/admin/files")

      assert render(view) =~ file.title
    end

    test "saves new file", %{conn: conn} do
      existing_file = file_fixture()
      {:ok, view, _html} = conn |> log_in_admin() |> live("/admin/files")

      valid_file = %{
        name: "sample.txt",
        content: File.read!("test/support/fixtures/sample.txt"),
        type: "text/plain"
      }

      IO.puts(File.read!("test/support/fixtures/sample.txt"))

      assert view
             |> file_input("form#upload-form", :file, [valid_file])
             |> render_upload("sample.txt")

      assert view |> element("form#upload-form button[type=submit]") |> render_click()

      # Assert the uploaded file is listed
      assert render(view) =~ "sample.txt"
      assert render(view) =~ "#{File.stat!(@valid_file.path).size} bytes"
    end
  end
end
