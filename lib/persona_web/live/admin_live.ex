defmodule PersonaWeb.AdminFilesLive do
  alias Persona.FileUpload
  alias Phoenix.LiveView.UploadEntry
  use PersonaWeb, :live_view

  @bucket_name "persona"

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:file, accept: ~w(.txt .md), external: &presign_upload/2)}
  end

  defp presign_upload(entry, socket) do
    key = Ecto.UUID.generate()

    {:ok, presigned_url} =
      ExAws.Config.new(:s3)
      |> ExAws.S3.presigned_url(:put, @bucket_name, key, expires_in: 300)

    meta = %{uploader: "S3", url: presigned_url, key: key, fields: %{}}

    {:ok, meta, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :file, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    consume_uploaded_entries(socket, :file, fn %{key: key},
                                               %UploadEntry{
                                                 client_name: title,
                                                 client_size: size
                                               } ->
      FileUpload.create_file(%{s3_key: key, size: size, title: title})
    end)

    {:noreply, socket}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
  defp error_to_string(_), do: "Something went wrong"

  def render(assigns) do
    ~H"""
    <div>
      <form id="upload-form" phx-submit="save" phx-change="validate">
        <.live_file_input upload={@uploads.file} />
        <button type="submit">Upload</button>
      </form>
      <%!-- lib/my_app_web/live/upload_live.html.heex --%>

      <%!-- use phx-drop-target with the upload ref to enable file drag and drop --%>
      <section phx-drop-target={@uploads.file.ref}>
        <%!-- render each file entry --%>
        <article :for={entry <- @uploads.file.entries} class="upload-entry">
          <figure>
            <.live_img_preview entry={entry} />
            <figcaption>{entry.client_name}</figcaption>
          </figure>

          <%!-- entry.progress will update automatically for in-flight entries --%>
          <progress value={entry.progress} max="100">{entry.progress}%</progress>

          <%!-- a regular click event whose handler will invoke Phoenix.LiveView.cancel_upload/3 --%>
          <button
            type="button"
            phx-click="cancel-upload"
            phx-value-ref={entry.ref}
            aria-label="cancel"
          >
            &times;
          </button>

          <%!-- Phoenix.Component.upload_errors/2 returns a list of error atoms --%>
          <p :for={err <- upload_errors(@uploads.file, entry)} class="alert alert-danger">
            {error_to_string(err)}
          </p>
        </article>

        <%!-- Phoenix.Component.upload_errors/1 returns a list of error atoms --%>
        <p :for={err <- upload_errors(@uploads.file)} class="alert alert-danger">
          {error_to_string(err)}
        </p>
      </section>
    </div>
    """
  end
end
