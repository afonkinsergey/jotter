defmodule JotterWeb.Schema do
  use Absinthe.Schema

  import_types(JotterWeb.Schema.Types)

  alias JotterWeb.Resolvers.Users
  alias JotterWeb.Resolvers.Friends

  query do

    @desc "Get a list of all users"
    field :get_users, list_of(:user_type) do
      resolve &Users.get_users/2
    end

    @desc "Search user by one or more fields"
    field :search_user, list_of(:user_type) do
      arg :input, :user_search_input_type

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

    @desc "Create new user"
    field :create_user, type: :user_answer do
      arg :input, non_null(:user_input_type)

      resolve &Users.create_user/2
    end

    @desc "Delete user by login and pass"
    field :delete_user, type: :user_type do
      arg :input, non_null(:user_delete_input_type)

      resolve &Users.delete_user/2
    end

    @desc "Update user params, except login and pass"
    field :update_user, type: :user_type do
      arg :input, non_null(:user_update_input_type)

      resolve &Users.update_user/2
    end

    @desc "Change login and/or password"
    field :change_login_pass, type: :user_type do
      arg :input, non_null(:user_change_login_input_type)
      resolve &Users.change_login_pass/2
    end

    @desc "Simple check valid user"
    field :check_auth_user, type: :user_type do
      arg :input, non_null(:user_check_auth_input_type)

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
