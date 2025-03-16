defmodule LifeComplex.FinchLogger do
  require Logger

  def attach do
    :telemetry.attach(
      "finch-logger",
      [:finch, :request, :stop],
      &__MODULE__.handle_event/4,
      %{}
    )
  end

  def handle_event(
        [:finch, :request, :stop],
        %{duration: duration},
        %{request: request, result: {:ok, response}} = res,
        _config
      ) do
    Logger.info("""
    [Finch] #{request.method |> to_string()} #{request.path}
    Status: #{response.status}, Duration: #{System.convert_time_unit(duration, :native, :millisecond)} ms
    Response: #{inspect(res)}
    """, request.private)

    :ok
  end

  def handle_event(
        [:finch, :request, :stop],
        %{duration: duration},
        %{request: request, result: {:error, reason}},
        _config
      ) do
    Logger.error("""
    [Finch] ERROR: #{request.method |> to_string()} #{request.path}
    Reason: #{inspect(reason)}, Duration: #{System.convert_time_unit(duration, :native, :millisecond)} ms
    """)

    :ok
  end
end
