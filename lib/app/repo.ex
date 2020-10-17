defmodule App.Repo do
  use Ecto.Repo,
    otp_app: :app,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query, only: [limit: 2, offset: 2, order_by: 2]

  def page_size, do: 20

  def paginate(query, opts) do
    %{
      page_size: page_size,
      page_number: _page_number,
      offset: offset,
      sort_direction: sort_direction,
      sort_field: sort_field
    } = paginate_params(opts)

    query
    |> order_by(^sort(%{sort_direction: sort_direction, sort_field: sort_field}))
    |> limit(^page_size)
    |> offset(^offset)
    |> all()
  end

  def paginate_params(opts) do
    page_size = get_page_size(opts["page_size"])
    page_number = get_page(opts["page"])

    sort_field = get_sort_field(opts["sort_field"])
    sort_direction = get_sort_direction(opts["sort_direction"])

    offset = page_size * (page_number - 1)

    %{
      page_size: page_size,
      page_number: page_number,
      offset: offset,
      sort_field: sort_field,
      sort_direction: sort_direction
    }
  end

  def sort(%{"sort_field" => field, "sort_direction" => direction}) do
    {String.to_atom(String.downcase(direction)), String.to_atom(field)}
  end

  def sort(_other) do
    {:asc, :id}
  end

  def get_page_size(str) when is_binary(str) do
    case Integer.parse(str) do
      {size, _} -> size
      _ -> 20
    end
  end

  def get_page_size(number) when is_integer(number), do: number
  def get_page_size(_), do: 20

  def get_page(str) when is_binary(str) do
    case Integer.parse(str) do
      {page, _} -> page
      _ -> 1
    end
  end

  def get_page(number) when is_integer(number), do: number
  def get_page(_), do: 1

  def get_sort_field(field) when is_binary(field), do: String.to_atom(field)
  def get_sort_field(_), do: :id

  def get_sort_direction(direction)
      when is_binary(direction) and (direction == "asc" or direction == "desc"),
      do: String.to_atom(String.downcase(direction))

  def get_sort_direction(_), do: :asc
end
