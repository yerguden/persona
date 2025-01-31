# add s3 mocks
Mox.defmock(Persona.MockS3, for: Persona.Storage.S3Client)
Application.put_env(:persona, :s3_client, Persona.MockS3)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Persona.Repo, :manual)
