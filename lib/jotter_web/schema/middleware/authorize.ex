defmodule JotterWeb.Schema.Middleware.Authorize do
  @behaviour Absinthe.Middleware

  # Если контекст из guardian сожержит стуркутуру юзера
  # передаём её дальше в резолвер
  def call(resolution, _) do
    with %{current_user: _current_user} <- resolution.context do
      resolution
    else
      _ -> resolution |> Absinthe.Resolution.put_result({:error, "unauthorized"})
    end
  end
end
