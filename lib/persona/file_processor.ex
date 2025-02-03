defmodule Persona.FileProcessor do
  alias Persona.FileUpload

  def process_file(%FileUpload.File{}) do
    # Get aws file 
    # Stream
    # chunk at 500 characters or so 
    # save to chunks table
    :timer.sleep(3000)
    {:error, "todo"}
  end
end
