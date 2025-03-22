defmodule LifeComplexWeb.LifeComplexityLive.Index do
  use LifeComplexWeb, :live_view

  alias LifeComplex.Research
  alias LifeComplex.Research.LifeComplexity

  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:life_complexities, Research.list_life_complexities())
     |> assign(:llm_result, nil)
     |> put_request_id(Map.new(get_connect_info(socket, :x_headers) || %{}))
     |> assign(:loading_api, false)}
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
  def handle_event("delete", %{"id" => id}, socket) do
    life_complexity = Research.get_life_complexity!(id)
    {:ok, _} = Research.delete_life_complexity(life_complexity)

    {:noreply, stream_delete(socket, :life_complexities, life_complexity)}
  end

  @impl true
  def handle_event("fetch_from_api", _params, socket) do
    if socket.assigns.loading_api do
      {:noreply, socket}
    else
      metadata = Logger.metadata()

      Task.async(fn ->
        :poolboy.transaction(:llm_worker_pool, fn pid ->
          LifeComplex.Worker.fetch_data(pid, metadata)
        end)
      end, 30_000)

      {:noreply, assign(socket, :loading_api, true)}
    end
  end

  @impl true
  def handle_info({LifeComplexWeb.LifeComplexityLive.FormComponent, {:saved, life_complexity}}, socket) do
    {:noreply, stream_insert(socket, :life_complexities, life_complexity)}
  end

  def handle_info({_, {:api_response, response}}, socket) do
    {:noreply,
     socket
     |> assign(:llm_result, response)
     |> assign(:loading_api, false)}
  end

  def handle_info({_, {:api_error, reason}}, socket) do
    {:noreply,
     socket
     |> assign(:loading_api, false)
     |> put_flash(:error, "Request LLM error #{inspect(reason)}")}
  end

  def handle_info(msg, socket) do
    Logger.info("Unhandled message #{inspect(msg)}")

    {:noreply, socket}
  end

  def put_request_id(socket, %{"x-request-id" => request_id}) do
    Logger.metadata([request_id: request_id])

    assign(socket, :request_id, request_id)
  end
  
  def put_request_id(%{assigns: %{request_id: _request_id}} = socket, _connect_info) do
    socket
  end
  
  def put_request_id(socket, _connect_info) do
    socket
  end
end
