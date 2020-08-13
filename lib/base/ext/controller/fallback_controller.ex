defmodule App.Base.Ext.Controller.FallbackController do
  use AppWeb, :controller

  def call(conn, :ok) do
    json(conn, %{data: %{}})
  end

  def call(conn, {:ok, nil}) do
    json(conn, %{data: %{}})
  end

  def call(conn, {:ok, result}) when is_map(result) do
    conn
    |> json(%{data: result})
  end

  def call(conn, {:error, failed_operation, failed_value, changes_so_far})
      when is_atom(failed_operation) do
    handle_failed_transaction(failed_operation, failed_value, changes_so_far)

    conn
    |> put_status(:bad_request)
    |> json(%{errors: humanize_errors(failed_value)})
  end

  def call(conn, {:missing_params, params}) when is_list(params) do
    param_names = Enum.join(params, ", ")
    handle_error(conn, "#{humanize_field(param_names)} are mandatory")
  end

  def call(conn, {:missing_params, param}) do
    handle_error(conn, "#{humanize_field(param)} is mandatory")
  end

  def call(conn, {:error, %Ecto.Changeset{} = chset}) do
    conn
    |> put_status(:bad_request)
    |> json(%{errors: humanize_errors(chset)})
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> json(%{message: "Unauthorized access"})
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(:forbidden)
    |> json(%{message: "Forbidden access"})
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> json(%{message: "Not found"})
  end

  def call(conn, {:error, error_str}) when is_binary(error_str) do
    conn
    |> put_status(:bad_request)
    |> json(%{errors: [error_str]})
  end

  def call(conn, {:error, _}) do
    conn
    |> put_status(:bad_request)
    |> json(%{message: "Bad request"})
  end

  def handle_canary_not_found(conn) do
    conn
    |> put_status(:not_found)
    |> json(%{message: "Not found"})
    |> halt()
  end

  def handle_canary_unauthorized(conn) do
    conn
    |> put_status(:not_found)
    |> json(%{message: "Not found"})
    |> halt()
  end

  defp handle_error(conn, error_message) do
    conn
    |> put_status(400)
    |> json(%{errors: [error_message]})
  end
end
