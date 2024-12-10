defmodule PersonaWeb.FileLive.Index do
  use PersonaWeb, :live_view

  alias Persona.FileUpload
  alias Persona.FileUpload.File

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :files, FileUpload.list_files())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit File")
    |> assign(:file, FileUpload.get_file!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New File")
    |> assign(:file, %File{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Files")
    |> assign(:file, nil)
  end

  @impl true
  def handle_info({PersonaWeb.FileLive.FormComponent, {:saved, file}}, socket) do
    {:noreply, stream_insert(socket, :files, file)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    file = FileUpload.get_file!(id)
    {:ok, _} = FileUpload.delete_file(file)

    {:noreply, stream_delete(socket, :files, file)}
  end
end
