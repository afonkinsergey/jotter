defmodule JotterWeb.Resolvers.Friends do
  alias Jotter.{User.Friendship}

  # Делаем запрос на добавление в друзья
  def send_friend_request(%{login: login, password: _password, friend_login: friend_login} = params, _) do
    with {:ok, %Friendship{}} <- Friendship.send_friend_request(params) do
      {:ok, %{login: login, friend_login: friend_login, message: "Friendship request from #{login} to #{friend_login} has been sent"}}
    else
      _ -> {:error, "Friendship is not created"}
    end
  end

  # Принимаем запрос в друзья
  def accept_friend_request(%{login: login, friend_login: friend_login, friend_password: _friend_password} = params, _) do
    with {:ok, %Friendship{}} <- Friendship.accept_friend_request(params) do
      {:ok, %{login: login, friend_login: friend_login, message: "Friendship request from #{login} to #{friend_login} has been accepted"}}
    else
      _ -> {:error, "Friendship has not created"}
    end
  end

  # Отклоняем запрос в друзья
  def reject_friend_request(%{login: login, friend_login: friend_login, friend_password: _friend_password} = params, _) do
    with {:ok} <- Friendship.reject_friend_request(params) do
      {:ok, %{login: login, friend_login: friend_login, message: "Friendship request from #{login} to #{friend_login} has been rejected"}}
    else
      _ -> {:error, "Request has not rejected"}
    end
  end

  # Удаляем из друзей друг друга
  def delete_from_friends(%{login: login, password: _password, friend_login: friend_login} = params, _) do
    with {:ok} <- Friendship.delete_from_friends(params) do
      {:ok, %{login: login, friend_login: friend_login, message: "Friendship #{login} and #{friend_login} is canceled"}}
    else
      _ -> {:error, "Friendship is not canceled"}
    end
  end

  # Узнаём кто мне отправил запрос в друзья
  def who_friend_request_me(%{login: _login, password: _password} = params, _) do
    with user_list when is_list(user_list) <- Friendship.who_friend_request_me(params) do
      {:ok, user_list}
    else
      _ -> {:error, "You have not a requests for friendship"}
    end
  end

  # Просмотр кому я отправил запрос на добавление в друзья
  def my_friend_requests(%{login: _login, password: _password} = params, _) do
    with user_list when is_list(user_list) <- Friendship.my_friend_requests(params) do
      {:ok, user_list}
    else
      _ -> {:error, "You not sent a friend requests"}
    end
  end

  # Проверяем кто наши друзья
  def who_my_friends(%{login: _login, password: _password} = params, _) do
    with user_list when is_list(user_list) <- Friendship.who_my_friends(params) do
      {:ok, user_list}
    else
      _ -> {:error, "You have not a friends"}
    end
  end
end
