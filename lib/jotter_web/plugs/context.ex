defmodule JotterWeb.Plugs.Context do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  # Сотрим через guardian принимаемого из хедера токена
  # если токен есть возвращаем наполненный структурой юзера контекст
  defp build_context(conn) do
    with  ["Bearer " <> token] <- get_req_header(conn, "authorization"),
          {:ok, claims}        <- Jotter.Guardian.decode_and_verify(token),
          {:ok, user}          <- Jotter.Guardian.resource_from_claims(claims) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end
end
