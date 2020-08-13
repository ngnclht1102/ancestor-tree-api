defmodule App.Base.Ext.Helpers.SharedHelpers do
  @moduledoc """
    Shared helper functions between views and controllers
  """
  require Logger
  use Timex

  @humanize_field_map %{
    "phone_number_without_code" => "phone_number",
    "dob_year" => "age"
  }
  # failed_operation: :user,
  # failed_value: #Ecto.Changeset<action: :insert, changes: %{access_token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJKb2tlbiIsImVtYWlsIjoia2ltQHRoZWtpcmlubGFiLmNvbSIsImV4cCI6MTU4NjkyNjMxMiwiaWF0IjoxNTg2ODM5OTEyLCJpc3MiOiJKb2tlbiIsImp0aSI6IjJvMnBjdmdycnA4cnZ2amI2NDAwMDEzMSIsIm5iZiI6MTU4NjgzOTkxMn0.1jcx56PFjCvKyTtruQNYUsy2IAYDgtEONzcyyce0i0k", account_type: "personal", email: "kim@thekirinlab.com", first_name: "Kim", last_name: "Le", state: "pending_phone_number", type: "user"}, errors: [email: {"has already been taken", [constraint: :unique, constraint_name: "users_email_index"]}], data: #Tfw.Account.User<>, valid?: false>,
  # changes_so_far: %{}
  def handle_failed_transaction(failed_operation, failed_value, changes_so_far) do
    Logger.error(fn ->
      "failed_operation: #{inspect(failed_operation)}, failed_value: #{inspect(failed_value)}, changes_so_far: #{
        inspect(changes_so_far)
      }"
    end)

    {:error, failed_value}
  end

  @doc """
  A helper that transform changeset errors to a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Enum.reduce(opts, message, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end

  # show error message in a list
  def humanize_errors(changeset) do
    errors = errors_on(changeset)
    do_humanize_errors(errors)
  end

  defp do_humanize_errors(map) when is_map(map) do
    Map.keys(map)
    |> Enum.map(fn key ->
      values_str =
        map[key]
        |> List.flatten()
        |> Enum.map(&do_humanize_errors/1)
        |> Enum.join(", ")

      "#{humanize_field(key)} #{values_str}"
    end)
  end

  defp do_humanize_errors(str), do: str

  def humanize_field(field) when is_atom(field), do: humanize_field(Atom.to_string(field))

  def humanize_field(field) do
    field = @humanize_field_map[field] || field
    String.replace(field, "_", " ")
  end

  def to_iso8601(nil), do: nil

  def to_iso8601(%{__struct__: NaiveDateTime} = datetime) do
    datetime
    |> DateTime.from_naive!("Etc/UTC")
    |> DateTime.to_iso8601()
  end

  def to_iso8601(%{__struct__: struct} = datetime) do
    struct.to_iso8601(datetime)
  end

  def format_date(nil), do: nil

  def format_date(%Date{} = date) do
    Timex.format!(date, "%d %b %y", :strftime)
  end

  def format_date_time(nil), do: nil

  def format_date_time(datetime) do
    Timex.format!(datetime, "%d %b %Y, %H:%M", :strftime)
  end

  def display_boolean(nil), do: "-"
  def display_boolean(true), do: "Yes"
  def display_boolean(false), do: "No"
end
