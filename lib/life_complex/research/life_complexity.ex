defmodule LifeComplex.Research.LifeComplexity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "life_complexities" do
    field :age, :integer
    field :sex, :string
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(life_complexity, attrs) do
    life_complexity
    |> cast(attrs, [:age, :sex])
    |> validate_required([:age, :sex])
  end
end
