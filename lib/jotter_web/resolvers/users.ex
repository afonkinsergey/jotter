defmodule JotterWeb.Resolvers.Users do
  alias Jotter.{User, Repo}

  # получаем список всех юзеров
  def get_users(_, _) do
    {:ok, User |> Repo.all()}
  end

  # ищем юзеров по параметрам
  def search_user(%{} = params, _) do
    with list_of_users when is_list(list_of_users) <- User.search_user(params) do
      {:ok, list_of_users}
    else
      _ -> {:error, "User not found"}
    end
  end

  # создаём нового юзера
  def create_user(%{} = params, _) do
    with {:ok, %User{login: login}} <- User.create_user(params) do
      {:ok, %{login: login, message: "User was created"}}
    else
      _ -> {:error, "Can not add user"}
    end
  end

  # обновляем какие-либо параметры юзера
  def update_user(%{} = params, _) do
    with {:ok, %User{}} = updated_user <- User.update_user(params) do
      updated_user
    else
      _ -> {:error, "Can not update user"}
    end
  end

  # проверяем пару логин-пароль юзера
  def check_auth_user(%{} = params, _) do
    with {:ok, %User{}} = good_user <- User.check_auth_user(params) do
      good_user
    else
      _ -> {:error, "Login or password do not match"}
    end
  end

  # удаляем юзера по логину и паролю
  def delete_user(%{} = params, _) do
    with %{} = deleted_user <- User.delete_user(params) do
      {:ok, deleted_user}
    else
      _ -> {:error, "User not deleted"}
    end
  end

  def change_login_pass(%{} = params, _) do
    with %{} = updated_user <- User.change_login_pass(params) do
      {:ok, updated_user}
    else
      _ -> {:error, "Can not update users login or pass"}
    end
  end
end
