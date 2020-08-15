defmodule App.Family.FamilyManager do
  @moduledoc """
  family manager
  """
  alias App.Repo
  alias App.Family.Family

  def create_new_family(%Family{}, params) do
    Family.changeset(%Family{}, params)
    |> Repo.insert()
  end
end
