defmodule App.Event.Admin.EventManager do
  @moduledoc """
  family manager
  """
  alias App.Repo
  alias App.Event.Event
  alias App.Family.Family

  import Ecto.Query, only: [from: 2]

  # def load_family(current_admin, id) do
  #   from(
  #     f in Family,
  #     where: f.id == ^id,
  #     where: is_nil(f.deleted_at),
  #   ) |> Repo.one()
  # end

  def create_new_event(current_admin, current_family,  params) do
    Event.changeset(
      %Event{},
      Map.merge(
        params,
        %{
          "created_by_id" => current_admin.id,
          "family_id" => current_family.id
        }
      )
    )
    |> Repo.insert()
  end

  # def update_family(id, params) do
  #   family = Family |> Repo.get(id)

  #   if family do
  #     family |> Family.changeset(params) |> Repo.update()
  #   else
  #     {:error, %{message: :not_found}}
  #   end
  # end

  # def remove_family(id) do
  #   family = Family |> Repo.get(id)

  #   if family do
  #     family |> Family.delete_changeset() |> Repo.update()
  #   else
  #     {:error, %{message: :not_found}}
  #   end
  # end

  def list_events_of_given_family(current_family, params) do
    query = from(
      e in Event,
      where: e.family_id == ^current_family.id,
      where: is_nil(e.deleted_at)
    )
    count = query |> Repo.aggregate(:count, :id)
    records = query
      |> Repo.paginate(params)
    %{ count: count, records: records }
  end
end
