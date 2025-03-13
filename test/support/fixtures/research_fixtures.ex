defmodule LifeComplex.ResearchFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LifeComplex.Research` context.
  """

  @doc """
  Generate a life_complexity.
  """
  def life_complexity_fixture(attrs \\ %{}) do
    {:ok, life_complexity} =
      attrs
      |> Enum.into(%{
        age: 42,
        sex: "some sex"
      })
      |> LifeComplex.Research.create_life_complexity()

    life_complexity
  end
end
