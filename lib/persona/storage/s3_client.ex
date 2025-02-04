defmodule Persona.Storage.S3Client do
  @callback presigned_url(
              operation :: atom(),
              bucket :: String.t(),
              key :: String.t(),
              opts :: keyword()
            ) ::
              {:ok, String.t()} | {:error, any()}
  @callback download_file(s3_key :: String.t()) ::
              {:ok, Stream.t()} | {:error, any()}

  def presigned_url(operation, bucket, key, opts),
    do: impl().presigned_url(operation, bucket, key, opts)

  def download_file(s3_key) do
    impl().download_file(s3_key)
  end

  defp impl, do: Application.get_env(:persona, :s3_client, Persona.Storage.S3)
end

defmodule Persona.Storage.S3 do
  @behaviour Persona.Storage.S3Client

  def presigned_url(operation, bucket, key, opts) do
    ExAws.Config.new(:s3)
    |> ExAws.S3.presigned_url(operation, bucket, key, opts)
  end

  def download_file(s3_key) do
    {:error, :todo}
  end
end
