defmodule LifeComplexWeb.LifeComplexityLive.Show do
  use LifeComplexWeb, :live_view

  alias LifeComplex.Research

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:life_complexity, Research.get_life_complexity!(id))}
  end

  defp page_title(:show), do: "Show Life complexity"
  defp page_title(:edit), do: "Edit Life complexity"
end
