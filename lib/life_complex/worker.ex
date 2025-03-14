defmodule LifeComplex.Worker do
  use GenServer

  @llm_api_key Application.compile_env!(:life_complex, :llm_api_key)
  @llm_model "deepseek/deepseek-chat:free"
  @llm_api_url "https://openrouter.ai/api/v1/chat/completions"

  @session Req.new(base_url: @llm_api_url, headers: [{"Content-Type", "application/json"}, {"Authorization", "Bearer " <> @llm_api_key}])

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, nil}
  end
  
  def fetch_data(pid) do
    GenServer.call(pid, :fetch_data)
  end

  def handle_call(:fetch_data, _from, state) do
    json = %{
      model: @llm_model,
      messages: [
        %{role: "system", content: ""},
        %{role: "user", content: "Как дела, брат?"}
      ]
    }

    case Req.post(@session, json: json) do
      {:ok, %Req.Response{status: 200, body: %{"choices" => [%{"message" => resp}]}}} ->
        IO.inspect(resp, label: "RESP BODY")
        {:reply, {:api_response, resp}, state}

      {:ok, %Req.Response{status: 400, body: reason}} ->
        {:reply, {:api_error, reason}, state}

      {:error, %{reason: reason}} ->
        {:reply, {:api_error, reason}, state}
    end
  end
end
