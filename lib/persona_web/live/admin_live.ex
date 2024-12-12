defmodule PersonaWeb.AdminLive do
  use PersonaWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    files = [
      %{name: "File A", status: "processing"},
      %{name: "File B", status: "done"},
      %{name: "File C", status: "failed"}
    ]

    {:ok, assign(socket, files: files, upload: nil)}
  end

  @impl true
  def handle_event("upload", %{"file" => file}, socket) do
    # Handle file upload logic here
    {:noreply, assign(socket, upload: file)}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-page">
      <h1>Admin</h1>

      <div class="upload-section">
        <form phx-submit="upload">
          <input type="file" name="file" accept=".md" />
          <button type="submit">Upload</button>
        </form>
      </div>

      <div class="files-section">
        <h2>Files</h2>
        <table class="files-table">
          <thead>
            <tr>
              <th>File Name</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            <%= for file <- @files do %>
              <tr>
                <td>{file.name}</td>
                <td>{file.status}</td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>

      <style>
        .admin-page {
          font-family: Arial, sans-serif;
          padding: 20px;
        }

        .upload-section {
          margin-bottom: 20px;
        }

        .files-table {
          width: 100%;
          border-collapse: collapse;
        }

        .files-table th, .files-table td {
          border: 1px solid #ddd;
          padding: 8px;
        }

        .files-table th {
          background-color: #f4f4f4;
        }
      </style>
    </div>
    """
  end
end
