defmodule LifeComplex.Research do
  @moduledoc """
  The Research context.
  """

  import Ecto.Query, warn: false
  alias LifeComplex.Repo

  alias LifeComplex.Research.LifeComplexity

  @doc """
  Returns the list of life_complexities.

  ## Examples

      iex> list_life_complexities()
      [%LifeComplexity{}, ...]

  """
  def list_life_complexities do
    Repo.all(LifeComplexity)
  end

  @doc """
  Gets a single life_complexity.

  Raises `Ecto.NoResultsError` if the Life complexity does not exist.

  ## Examples

      iex> get_life_complexity!(123)
      %LifeComplexity{}

      iex> get_life_complexity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_life_complexity!(id), do: Repo.get!(LifeComplexity, id)

  @doc """
  Creates a life_complexity.

  ## Examples

      iex> create_life_complexity(%{field: value})
      {:ok, %LifeComplexity{}}

      iex> create_life_complexity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_life_complexity(attrs \\ %{}) do
    %LifeComplexity{}
    |> LifeComplexity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a life_complexity.

  ## Examples

      iex> update_life_complexity(life_complexity, %{field: new_value})
      {:ok, %LifeComplexity{}}

      iex> update_life_complexity(life_complexity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_life_complexity(%LifeComplexity{} = life_complexity, attrs) do
    life_complexity
    |> LifeComplexity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a life_complexity.

  ## Examples

      iex> delete_life_complexity(life_complexity)
      {:ok, %LifeComplexity{}}

      iex> delete_life_complexity(life_complexity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_life_complexity(%LifeComplexity{} = life_complexity) do
    Repo.delete(life_complexity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking life_complexity changes.

  ## Examples

      iex> change_life_complexity(life_complexity)
      %Ecto.Changeset{data: %LifeComplexity{}}

  """
  def change_life_complexity(%LifeComplexity{} = life_complexity, attrs \\ %{}) do
    LifeComplexity.changeset(life_complexity, attrs)
  end
end
