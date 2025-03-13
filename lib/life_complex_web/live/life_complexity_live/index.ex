defmodule LifeComplexWeb.LifeComplexityLive.Index do
  use LifeComplexWeb, :live_view

  alias LifeComplex.Research
  alias LifeComplex.Research.LifeComplexity

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :life_complexities, Research.list_life_complexities())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Life complexity")
    |> assign(:life_complexity, Research.get_life_complexity!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Life complexity")
    |> assign(:life_complexity, %LifeComplexity{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Life complexities")
    |> assign(:life_complexity, nil)
  end

  @impl true
  def handle_info({LifeComplexWeb.LifeComplexityLive.FormComponent, {:saved, life_complexity}}, socket) do
    {:noreply, stream_insert(socket, :life_complexities, life_complexity)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    life_complexity = Research.get_life_complexity!(id)
    {:ok, _} = Research.delete_life_complexity(life_complexity)

    {:noreply, stream_delete(socket, :life_complexities, life_complexity)}
  end
end
