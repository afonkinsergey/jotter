defmodule JotterWeb.Schema.Types do
  use Absinthe.Schema.Notation

  alias JotterWeb.Schema.Types

  import_types(Types.UserType)
  import_types(Types.FriendshipType)
  import_types(Types.SessionType)
end
