defmodule LifeComplex.Worker do
  use GenServer

  @llm_api_key Application.compile_env!(:life_complex, :llm_api_key)
  @llm_model "deepseek/deepseek-chat:free"
  @llm_api_url "https://openrouter.ai/api/v1/chat/completions"

  @llm_request Req.new(
                 base_url: @llm_api_url,
                 headers: [{"Content-Type", "application/json"}],
                 auth: {:bearer, @llm_api_key},
                 finch: LifeComplex.Finch
               )

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, nil}
  end

  def fetch_data(pid, metadata) do
    GenServer.call(pid, {:fetch_data, metadata})
  end

  def handle_call({:fetch_data, metadata}, _from, state) do
    json = %{
      model: @llm_model,
      messages: [
        %{role: "system", content: ""},
        %{role: "user", content: "Как дела, брат?"}
      ]
    }

    case Req.post(Req.merge(@llm_request, finch_private: metadata), json: json) do
      {:ok, %Req.Response{status: 200, body: %{"choices" => [%{"message" => resp}]}}} ->
        {:reply, {:api_response, resp}, state}

      {:ok, %Req.Response{status: 400, body: reason}} ->
        {:reply, {:api_error, reason}, state}

      {:error, %{reason: reason}} ->
        {:reply, {:api_error, reason}, state}
    end
  end
end
