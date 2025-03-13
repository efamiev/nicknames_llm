defmodule LifeComplexWeb.LifeComplexityLive.Index do
  use LifeComplexWeb, :live_view

  alias LifeComplex.Research
  alias LifeComplex.Research.LifeComplexity

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> stream(:life_complexities, Research.list_life_complexities())
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
  def handle_info({LifeComplexWeb.LifeComplexityLive.FormComponent, {:saved, life_complexity}}, socket) do
    {:noreply, stream_insert(socket, :life_complexities, life_complexity)}
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
      # Запускаем асинхронный запрос, чтобы не блокировать интерфейс
      Task.async(fn ->
        # Здесь должен быть ваш код для запроса к внешнему API
        # Например:
        # response = ApiClient.fetch_data(params)
        # Имитируем долгий запрос
        Process.sleep(1000)
        response = %{data: "Данные из API", timestamp: DateTime.utc_now()}

        # Отправляем сообщение обратно в LiveView процесс
        send(self(), {:api_response, response})
      end)

      {:noreply, assign(socket, :loading_api, true)}
    end
  end

  @impl true
  def handle_info({_, {:api_response, response}}, socket) do
    # Здесь обрабатываем полученные данные
    # Например, можно добавить их в коллекцию или обновить состояние

    # В качестве примера просто создадим новую запись
    # В реальном приложении здесь нужно адаптировать данные API к вашей структуре
    # new_complexity = %LifeComplexity{
    #   name: "Данные из API #{DateTime.utc_now()}",
    #   description: "Получено из внешнего API: #{inspect(response.data)}"
    # }
    # 
    # {:ok, saved_complexity} = Research.create_life_complexity(new_complexity)

    {:noreply,
     socket
     # |> stream_insert(:life_complexities, saved_complexity)
     |> assign(:loading_api, false)}
  end

  def handle_info(msg, socket) do
    IO.inspect(msg, label: "Unhandled message")

    {:noreply, socket}
  end
end
