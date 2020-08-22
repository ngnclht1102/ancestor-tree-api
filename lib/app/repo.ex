defmodule App.Repo do
  use Ecto.Repo,
    otp_app: :app,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [limit: 2, offset: 2]

  def page_size, do: 20

  # replace scrivener with our own simpler implementation since we don't need total entries count
  def paginate(query, opts) do
    page_size = page_size(opts["page_size"])
    page_number = page(opts["page"])
    offset = page_size * (page_number - 1)

    query
    |> limit(^page_size)
    |> offset(^offset)
    |> all()
  end

  def page_size(str) when is_binary(str) do
    case Integer.parse(str) do
      {size, _} -> size
      _ -> 20
    end
  end

  def page_size(number) when is_integer(number), do: number
  def page_size(_), do: 20

  def page(str) when is_binary(str) do
    case Integer.parse(str) do
      {page, _} -> page
      _ -> 1
    end
  end

  def page(number) when is_integer(number), do: number
  def page(_), do: 1
end
