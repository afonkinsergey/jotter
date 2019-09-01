defmodule Jotter.User.Session do
  alias Jotter.{Repo, User}

  def authenticate(args) do
    with %User{} = user <- Repo.get_by(User, login: args.login, password: args.password) do
      {:ok, user}
    else
      _ -> {:error, "Incorrect login credentials"}
    end

    # user <- Repo.get_by(User, login: String.downcase(args.login))

    # case check_password(user, args) do
    #   true -> {:ok, user}
    #   _    -> {:error, "Incorrect login credentials"}
    # end
  end

  # defp check_password(user, args) do
  #   case user do
  #     nil -> Comeonin.Argon2.dummy_checkpw()
  #     _   -> Comeonin.Argon2.checkpw(args.password, user.password_hash)
  #   end
  # end
end
