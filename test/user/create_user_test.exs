defmodule JotterWeb.User.CreateUserTest do
  use Jotter.RepoCase

  alias Jotter.{User, Repo}

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "create user" do
    # Use the repository as usual
    assert %User{} == Repo.insert!(%User{login: "test", password: "123", email: "test@test.com", name: "Test", surname: "Test"})
  end
end
