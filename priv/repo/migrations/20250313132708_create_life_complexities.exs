defmodule LifeComplex.Repo.Migrations.CreateLifeComplexities do
  use Ecto.Migration

  def change do
    create table(:life_complexities) do
      add :age, :integer
      add :sex, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:life_complexities, [:user_id])
  end
end
