defmodule LifeComplex.ResearchTest do
  use LifeComplex.DataCase

  alias LifeComplex.Research

  describe "life_complexities" do
    alias LifeComplex.Research.LifeComplexity

    import LifeComplex.ResearchFixtures

    @invalid_attrs %{age: nil, sex: nil}

    test "list_life_complexities/0 returns all life_complexities" do
      life_complexity = life_complexity_fixture()
      assert Research.list_life_complexities() == [life_complexity]
    end

    test "get_life_complexity!/1 returns the life_complexity with given id" do
      life_complexity = life_complexity_fixture()
      assert Research.get_life_complexity!(life_complexity.id) == life_complexity
    end

    test "create_life_complexity/1 with valid data creates a life_complexity" do
      valid_attrs = %{age: 42, sex: "some sex"}

      assert {:ok, %LifeComplexity{} = life_complexity} =
               Research.create_life_complexity(valid_attrs)

      assert life_complexity.age == 42
      assert life_complexity.sex == "some sex"
    end

    test "create_life_complexity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Research.create_life_complexity(@invalid_attrs)
    end

    test "update_life_complexity/2 with valid data updates the life_complexity" do
      life_complexity = life_complexity_fixture()
      update_attrs = %{age: 43, sex: "some updated sex"}

      assert {:ok, %LifeComplexity{} = life_complexity} =
               Research.update_life_complexity(life_complexity, update_attrs)

      assert life_complexity.age == 43
      assert life_complexity.sex == "some updated sex"
    end

    test "update_life_complexity/2 with invalid data returns error changeset" do
      life_complexity = life_complexity_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Research.update_life_complexity(life_complexity, @invalid_attrs)

      assert life_complexity == Research.get_life_complexity!(life_complexity.id)
    end

    test "delete_life_complexity/1 deletes the life_complexity" do
      life_complexity = life_complexity_fixture()
      assert {:ok, %LifeComplexity{}} = Research.delete_life_complexity(life_complexity)

      assert_raise Ecto.NoResultsError, fn ->
        Research.get_life_complexity!(life_complexity.id)
      end
    end

    test "change_life_complexity/1 returns a life_complexity changeset" do
      life_complexity = life_complexity_fixture()
      assert %Ecto.Changeset{} = Research.change_life_complexity(life_complexity)
    end
  end
end
