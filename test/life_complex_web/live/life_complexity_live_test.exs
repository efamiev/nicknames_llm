defmodule LifeComplexWeb.LifeComplexityLiveTest do
  use LifeComplexWeb.ConnCase

  import Phoenix.LiveViewTest
  import LifeComplex.ResearchFixtures

  @create_attrs %{age: 42, sex: "some sex"}
  @update_attrs %{age: 43, sex: "some updated sex"}
  @invalid_attrs %{age: nil, sex: nil}

  defp create_life_complexity(_) do
    life_complexity = life_complexity_fixture()
    %{life_complexity: life_complexity}
  end

  describe "Index" do
    setup [:create_life_complexity]

    test "lists all life_complexities", %{conn: conn, life_complexity: life_complexity} do
      {:ok, _index_live, html} = live(conn, ~p"/life_complexities")

      assert html =~ "Listing Life complexities"
      assert html =~ life_complexity.sex
    end

    test "saves new life_complexity", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/life_complexities")

      assert index_live |> element("a", "New Life complexity") |> render_click() =~
               "New Life complexity"

      assert_patch(index_live, ~p"/life_complexities/new")

      assert index_live
             |> form("#life_complexity-form", life_complexity: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#life_complexity-form", life_complexity: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/life_complexities")

      html = render(index_live)
      assert html =~ "Life complexity created successfully"
      assert html =~ "some sex"
    end

    test "updates life_complexity in listing", %{conn: conn, life_complexity: life_complexity} do
      {:ok, index_live, _html} = live(conn, ~p"/life_complexities")

      assert index_live
             |> element("#life_complexities-#{life_complexity.id} a", "Edit")
             |> render_click() =~
               "Edit Life complexity"

      assert_patch(index_live, ~p"/life_complexities/#{life_complexity}/edit")

      assert index_live
             |> form("#life_complexity-form", life_complexity: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#life_complexity-form", life_complexity: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/life_complexities")

      html = render(index_live)
      assert html =~ "Life complexity updated successfully"
      assert html =~ "some updated sex"
    end

    test "deletes life_complexity in listing", %{conn: conn, life_complexity: life_complexity} do
      {:ok, index_live, _html} = live(conn, ~p"/life_complexities")

      assert index_live
             |> element("#life_complexities-#{life_complexity.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#life_complexities-#{life_complexity.id}")
    end
  end

  describe "Show" do
    setup [:create_life_complexity]

    test "displays life_complexity", %{conn: conn, life_complexity: life_complexity} do
      {:ok, _show_live, html} = live(conn, ~p"/life_complexities/#{life_complexity}")

      assert html =~ "Show Life complexity"
      assert html =~ life_complexity.sex
    end

    test "updates life_complexity within modal", %{conn: conn, life_complexity: life_complexity} do
      {:ok, show_live, _html} = live(conn, ~p"/life_complexities/#{life_complexity}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Life complexity"

      assert_patch(show_live, ~p"/life_complexities/#{life_complexity}/show/edit")

      assert show_live
             |> form("#life_complexity-form", life_complexity: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#life_complexity-form", life_complexity: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/life_complexities/#{life_complexity}")

      html = render(show_live)
      assert html =~ "Life complexity updated successfully"
      assert html =~ "some updated sex"
    end
  end
end
