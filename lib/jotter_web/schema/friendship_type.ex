defmodule JotterWeb.Schema.Types.FriendshipType do
  use Absinthe.Schema.Notation

  object :friendship_type do
    field :login, :string
    field :friend_login, :string
    field :message, :string
  end

  input_object :friendship_request_delete_input_type do
    field :login, non_null(:string)
    field :password, non_null(:string)
    field :friend_login, non_null(:string)
  end

  input_object :friendship_accept_reject_request_input_type do
    field :login, non_null(:string)
    field :friend_login, non_null(:string)
    field :friend_password, non_null(:string)
  end
end
