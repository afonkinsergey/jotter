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
  end

  mutation do
    field :create_user, :user_answer do
      # arg :id, non_null(:id)
      arg :login, non_null(:string)
      arg :password, non_null(:string)
      arg :email, non_null(:string)
      arg :name, non_null(:string)
      arg :surname, non_null(:string)
      arg :age, non_null(:integer)
      arg :sex, non_null(:string)
      arg :city, non_null(:string)

      resolve &Users.create_user/2
    end

    field :delete_user, :user do
      # arg :id, :integer
      arg :login, non_null(:string)
      arg :password, non_null(:string)

      resolve &Users.delete_user/2
    end

    field :update_user, :user do
      arg :id, :integer
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

    field :send_friend_request, :user do
      arg :user_login, non_null(:string)
      arg :user_password, non_null(:string)
      arg :friend_login, non_null(:string)

      resolve &Friends.send_friend_request/2
    end
  end

  object :user do
    field :id, :id
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
end
