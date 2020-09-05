defmodule App.Repo do
  use Ecto.Repo,
    otp_app: :app,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [limit: 2, offset: 2, order_by: 2]

  def page_size, do: 20

  def paginate(query, opts) do
    %{ page_size: page_size, page_number: _page_number, offset: offset } = paginate_params(opts)

    params =
      opts
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(opts, "sort_direction")
    {:ok, sort_field} = Map.fetch(opts, "sort_field")
    query
    |> order_by(^sort(opts))
    |> limit(^page_size)
    |> offset(^offset)
    |> all()
  end

  def paginate_params(opts) do
    page_size = page_size(opts["page_size"])
    page_number = page(opts["page"])
    offset = page_size * (page_number - 1)

    %{ page_size: page_size, page_number: page_number, offset: offset }
  end

  def sort(%{"sort_field" => field, "sort_direction" => direction}) do
    {String.to_atom(String.downcase(direction)), String.to_atom(field)}
  end

  def sort(_other) do
    {:asc, :id}
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
