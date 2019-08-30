defmodule JotterWeb.Schema do
  use Absinthe.Schema

  alias JotterWeb.Resolvers.Users
  alias JotterWeb.Resolvers.Friends

  query do
    field :get_users, list_of(:user) do
      resolve &Users.get_users/2
    end

    field :search_user, list_of(:user) do
      arg :login, :string
      arg :email, :string
      arg :name, :string
      arg :surname, :string
      arg :age, :integer
      arg :sex, :string
      arg :city, :string

      resolve &Users.search_user/2
    end

    field :who_friend_request_me, list_of(:friends) do
      arg :login, non_null(:string)
      arg :password, non_null(:string)

      resolve &Friends.who_friend_request_me/2
    end

    field :my_friend_requests, list_of(:friends) do
      arg :login, non_null(:string)
      arg :password, non_null(:string)

      resolve &Friends.my_friend_requests/2
    end

    field :who_my_friends, list_of(:friends) do
      arg :login, non_null(:string)
      arg :password, non_null(:string)

      resolve &Friends.who_my_friends/2
    end
  end

  mutation do
    field :create_user, :user_answer do
      # arg :id, non_null(:id)
      arg :login, non_null(:string)
      arg :password, non_null(:string)
      arg :email, non_null(:string)
      arg :name, non_null(:string)
      arg :surname, :string
      arg :age, :string
      arg :sex, :string
      arg :city, :string

      resolve &Users.create_user/2
    end

    field :delete_user, :user do
      # arg :id, :integer
      arg :login, non_null(:string)
      arg :password, non_null(:string)

      resolve &Users.delete_user/2
    end

    field :update_user, :user do
      # arg :id, :integer
      arg :login, non_null(:string)
      arg :password, non_null(:string)
      arg :email, :string
      arg :name, :string
      arg :surname, :string
      arg :age, :integer
      arg :sex, :string
      arg :city, :string

      resolve &Users.update_user/2
    end

    field :change_login_pass, :user do
      arg :origin_login, non_null(:string)
      arg :origin_password, non_null(:string)
      arg :login, :string
      arg :password, :string

      resolve &Users.change_login_pass/2
    end

    field :check_auth_user, :user do
      arg :login, non_null(:string)
      arg :password, non_null(:string)

      resolve &Users.check_auth_user/2
    end

    field :send_friend_request, :friendship do
      arg :login, non_null(:string)
      arg :password, non_null(:string)
      arg :friend_login, non_null(:string)

      resolve &Friends.send_friend_request/2
    end

    field :accept_friend_request, :friendship do
      arg :login, non_null(:string)
      arg :friend_login, non_null(:string)
      arg :friend_password, non_null(:string)

      resolve &Friends.accept_friend_request/2
    end

    field :reject_friend_request, :friendship do
      arg :login, non_null(:string)
      arg :friend_login, non_null(:string)
      arg :friend_password, non_null(:string)

      resolve &Friends.reject_friend_request/2
    end

    field :delete_from_friends, :friendship do
      arg :login, non_null(:string)
      arg :password, non_null(:string)
      arg :friend_login, non_null(:string)

      resolve &Friends.delete_from_friends/2
    end
  end

  object :user do
    # field :id, :id
    field :login, :string
    field :password, :string
    field :email, :string
    field :name, :string
    field :surname, :string
    field :age, :integer
    field :sex, :string
    field :city, :string
  end

  object :user_answer do
    field :login, :string
    field :message, :string
  end

  object :friendship do
    field :login, :string
    field :friend_login, :string
    field :message, :string
  end

  object :friends do
    field :login, :string
    field :name, :string
    field :surname, :string
  end
end
