defmodule App.Base.Ext.Helper.AuthToken do
  use Joken.Config

  require Logger
  # token will expire after 1000 days
  @expire_in 24 * 90 * 60 * 60 * 1000

  def token_config, do: default_claims(default_exp: @expire_in)

  def verify_token(token) do
    verify_and_validate(token)
    |> case do
      {:ok, claim} ->
        {:ok, claim}

      {:error, error_msg} ->
        Logger.warn("Invalid JWT token: #{inspect(error_msg)}")
        {:error, "Invalid token"}
    end
  end
end
