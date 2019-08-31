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

    @desc "Who send friend request to me"
    field :who_friend_request_me, list_of(:user_type) do
      arg :input, non_null(:friendship_friends_input_type)

      resolve &Friends.who_friend_request_me/2
    end

    @desc "To whom did I send a friend request"
    field :my_friend_requests, list_of(:user_type) do
      arg :input, non_null(:friendship_friends_input_type)

      resolve &Friends.my_friend_requests/2
    end

    @desc "List of my freinds"
    field :who_my_friends, list_of(:user_type) do
      arg :input, non_null(:friendship_friends_input_type)

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

    @desc "Send friend request from user to potential friend"
    field :send_friend_request, type: :friendship_type do
      arg :input, non_null(:friendship_request_delete_input_type)

      resolve &Friends.send_friend_request/2
    end

    @desc "Accept request from user to friend"
    field :accept_friend_request, type: :friendship_type do
      arg :input, non_null(:friendship_accept_reject_request_input_type)

      resolve &Friends.accept_friend_request/2
    end

    @desc "Reject friendship request from friend to user"
    field :reject_friend_request, type: :friendship_type do
      arg :input, non_null(:friendship_accept_reject_request_input_type)

      resolve &Friends.reject_friend_request/2
    end

    @desc "Delete freindship pair"
    field :delete_from_friends, type: :friendship_type do
      arg :input, non_null(:friendship_request_delete_input_type)

      resolve &Friends.delete_from_friends/2
    end
  end
end
