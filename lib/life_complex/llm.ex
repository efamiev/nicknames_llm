defmodule LifeComplex.Llm do
  @llm_api_key Application.compile_env!(:life_complex, :llm_api_key)

  def fetch_data(pid) do
    url = "https://openrouter.ai/api/v1/chat/completions"
    headers = [{"Content-Type", "application/json"}, {"Authorization", "Bearer " <> @llm_api_key}]

    json = %{
      model: "deepseek/deepseek-chat:free",
      messages: [
        %{role: "system", content: ""},
        %{role: "user", content: "Как дела?"}
      ]
    }

    case Req.post(url, json: json, headers: headers) do
      {:ok, %Req.Response{status: 200, body: %{"choices" => [%{"message" => resp}]}}} ->
        send(pid, {:api_response, resp})

      {:ok, %Req.Response{status: 400, body: reason}} ->
        send(pid, {:api_error, reason})

      {:error, %{reason: reason}} ->
        send(pid, {:api_error, reason})
    end
  end
end
