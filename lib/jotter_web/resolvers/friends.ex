defmodule JotterWeb.Resolvers.Friends do
  alias Jotter.{User.Friendship}

  # Делаем запрос на добавление в друзья
  # input принимает login:, password:, friend_login:
  def send_friend_request(%{input: params}, _) do
    with {:ok, %Friendship{}} <- Friendship.send_friend_request(params) do
      {:ok, %{login: params.login, friend_login: params.friend_login, message: "Friendship request from #{params.login} to #{params.friend_login} has been sent"}}
    else
      _ -> {:error, "Friendship is not created"}
    end
  end

  # Принимаем запрос в друзья
  # input принимает поля login:, friend_login:, friend_password:
  # то есть запрос принимает именно друг
  def accept_friend_request(%{input: params}, _) do
    with {:ok, %Friendship{}} <- Friendship.accept_friend_request(params) do
      {:ok, %{login: params.login, friend_login: params.friend_login, message: "Friendship request from #{params.login} to #{params.friend_login} has been accepted"}}
    else
      _ -> {:error, "Friendship has not created"}
    end
  end

  # Отклоняем запрос в друзья
  # input принимает поля login:, friend_login:, friend_password:
  # то есть отклоняет запрос именно друг
  def reject_friend_request(%{input: params}, _) do
    with :ok <- Friendship.reject_friend_request(params) do
      {:ok, %{login: params.login, friend_login: params.friend_login, message: "Friendship request from #{params.login} to #{params.friend_login} has been rejected"}}
    else
      _ -> {:error, "Request has not rejected"}
    end
  end

  # Удаляем из друзей друг друга
  # input принимает login:, password:, friend_login:
  def delete_from_friends(%{input: params}, _) do
    with :ok <- Friendship.delete_from_friends(params) do
      {:ok, %{login: params.login, friend_login: params.friend_login, message: "Friendship #{params.login} and #{params.friend_login} is canceled"}}
    else
      _ -> {:error, "Friendship is not canceled"}
    end
  end

  # Узнаём кто мне отправил запрос в друзья
  # input принимает login:, password:
  def who_friend_request_me(%{input: params}, _) do
    with {:ok, user_list}  <- Friendship.who_friend_request_me(params) do
      {:ok, user_list}
    else
      _ -> {:error, "You have not a requests for friendship"}
    end
  end

  # Просмотр кому я отправил запрос на добавление в друзья
  # input принимает login:, password:
  def my_friend_requests(%{input: params}, _) do
    with {:ok, user_list} <- Friendship.my_friend_requests(params) do
      {:ok, user_list}
    else
      _ -> {:error, "You did not send friends requests"}
    end
  end

  # Проверяем кто наши друзья
  # input принимает login:, password:
  def who_my_friends(%{input: params}, _) do
    with {:ok, user_list} <- Friendship.who_my_friends(params) do
      {:ok, user_list}
    else
      _ -> {:error, "You have not a friends"}
    end
  end
end
