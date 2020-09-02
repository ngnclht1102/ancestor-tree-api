defmodule App.Factory do
  @moduledoc """
  All ExMachina factories are here
  """
  use ExMachina.Ecto, repo: App.Repo

  use App.Factory.{
    AccountFactory,
    FamilyFactory,
    PersonFactory
  }
end
