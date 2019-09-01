defmodule JotterWeb.Resolvers.Sessions do
  alias Jotter.{User, Guardian}

  def login_user(%{input: input}, _) do
    with  {:ok, user} <- User.Session.authenticate(input),
          {:ok, jwt_token, _} <- Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt_token, user: user}}
    end
  end
end
