defmodule JotterWeb.Resolvers.Users do
  alias Jotter.User

  # получаем список всех юзеров
  def get_users(_, _) do
    {:ok, User.all_users()}
  end

  # ищем юзеров по параметрам
  # input могут быть один или более: login:, email:, name:, surname:, age:, sex:, city:
  def search_user(%{input: params}, _) do
    with {:ok, user_list} <- User.search_user(params) do
      {:ok, user_list}
    else
      _ -> {:error, "User not found"}
    end
  end

  # создаём нового юзера
  # input обязятельные поля: login:, password:, email:, name:
  def create_user(%{input: params}, _) do
    with {:ok, %User{login: login}} <- User.create_user(params) do
      {:ok, %{login: login, message: "User was created"}}
    else
      _ -> {:error, "Can not add user"}
    end
  end

  # обновляем какие-либо параметры юзера
  # обновлять можем %{email: _email, name: _name, surname: _surname, age: _age, sex: _sex, city: _city}
  def update_user(%{login: _login, password: _password} = params, _) do
    with {:ok, updated_user} <- User.update_user(params) do
      {:ok, updated_user}
    else
      _ -> {:error, "Can not update user"}
    end
  end

  # проверяем пару логин-пароль юзера
  def check_auth_user(%{login: _login, password: _password} = params, _) do
    with {:ok, valid_user} <- User.check_auth_user(params) do
      {:ok, valid_user}
    else
      _ -> {:error, "Login or password do not match"}
    end
  end

  # удаляем юзера по логину и паролю
  # input принимает login:, password:
  def delete_user(%{input: params}, _) do
    with {:ok, deleted_user} <- User.delete_user(params) do
      {:ok, deleted_user}
    else
      _ -> {:error, "User not deleted"}
    end
  end

  # обновляем какие-либо логин или пароль юзера
  # новые логин и/или пароль %{login: _login, password: _password}
  def change_login_pass(%{origin_login: _origin_login, origin_password: _origin_password} = params, _) do
    with {:ok, updated_user} <- User.change_login_pass(params) do
      {:ok, updated_user}
    else
      _ -> {:error, "Can not update users login or pass"}
    end
  end
end
