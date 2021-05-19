defmodule App.Repo do
  use Ecto.Repo,
    otp_app: :app,
    adapter: Ecto.Adapters.Postgres

  import Ecto.Query
  alias App.Base.Ext.Utils.StringUtils

  def page_size, do: 20

  def paginate(query, opts) do
    %{
      page_size: page_size,
      page_number: _page_number,
      offset: offset,
      sort_direction: sort_direction,
      sort_field: sort_field,
      filters: filters
    } = paginate_params(opts)

    query
    |> build_filter_condition(filters)
    |> order_by(^sort(%{"sort_direction" => sort_direction, "sort_field" => sort_field}))
    |> limit(^page_size)
    |> offset(^offset)
    |> all()
  end

  def paginate_params(opts) do
    filters =
      try do
        filter_raw = Poison.decode!(opts["filter"])
        filter_raw |> Map.fetch!("arr")
      rescue
        _ -> []
      end

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
      sort_direction: sort_direction,
      filters: filters
    }
  end

  def build_filter_condition(query, filters) do
    Enum.reduce(filters, query, &do_build_filter_condition(&1, &2))
  end

  defp do_build_filter_condition(
         %{"field" => field, "value" => value, "operation" => operation},
         acc
       ) do
    atom_field = String.to_atom(field)
    acc |> where_operation(field, StringUtils.vietnamese_to_ascii(value), operation)
  end

  defp do_build_filter_condition(_, acc), do: acc

  defp where_operation(query, field, value, operation) when operation == "ilike" do
    atom_field = String.to_atom(field)
    query |> where([i], ilike(field(i, ^atom_field), ^value))
  end

  defp where_operation(query, field, value, operation) when operation == "==" do
    atom_field = String.to_atom(field)
    query |> where([i], field(i, ^atom_field) == ^value)
  end

  defp where_operation(query, field, value, operation) when operation == ">=" do
    atom_field = String.to_atom(field)
    query |> where([i], field(i, ^atom_field) >= ^value)
  end

  defp where_operation(query, field, value, operation) when operation == ">" do
    atom_field = String.to_atom(field)
    query |> where([i], field(i, ^atom_field) > ^value)
  end

  defp where_operation(query, field, value, operation) when operation == "<=" do
    atom_field = String.to_atom(field)
    query |> where([i], field(i, ^atom_field) <= ^value)
  end

  defp where_operation(query, field, value, operation) when operation == "<" do
    atom_field = String.to_atom(field)
    query |> where([i], field(i, ^atom_field) < ^value)
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

  def get_sort_field(field) when is_binary(field), do: field
  def get_sort_field(_), do: "id"

  def get_sort_direction(direction)
      when direction == "asc" or direction == "desc" or direction == "ASC" or direction == "DESC",
      do: direction

  def get_sort_direction(_), do: "asc"
end
