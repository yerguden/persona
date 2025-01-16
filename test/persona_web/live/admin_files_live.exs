defmodule AdminFilesLiveTest do
  use PersonaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Persona.FileUploadFixtures

  @admin_username System.fetch_env!("ADMIN_USERNAME")
  @admin_password System.fetch_env!("ADMIN_PASSWORD")

  def log_in_admin(conn) do
    # Encode Basic Auth credentials
    auth_header = Plug.BasicAuth.encode_basic_auth(@admin_username, @admin_password)

    # Simulate a connection with the Authorization header
    put_req_header(conn, "authorization", auth_header)
  end

  describe "AdminFilesLive" do
    test "renders upload form", %{conn: conn} do
      conn = log_in_admin(conn)

      {:ok, view, _html} = live(conn, "/admin/files")

      assert render(view) =~ "Upload"
    end
  end
end
