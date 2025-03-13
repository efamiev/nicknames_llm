defmodule LifeComplex.Llm do
  @llm_api_key Application.compile_env!(:life_complex, :llm_api_key)

  def fetch_data(pid) do
    url = "https://openrouter.ai/api/v1/chat/completions"
    headers = [{"Content-Type", "application/json"}, {"Authorization", "Bearer " <> @llm_api_key}]

    json = %{prompt: "Your request"}

    case Req.post(url, json: json, headers: headers) do
      {:ok, %Req.Response{status: 200, body: response_body}} ->
        response = Jason.decode!(response_body)
        send(pid, {:api_response, response})

      {:ok, %Req.Response{status: 400, body: reason}} ->
        send(pid, {:api_error, reason})

      {:error, %{reason: reason}} ->
        send(pid, {:api_error, reason})
    end
  end
end
