defmodule JotterWeb.Schema.Types.UserType do
  use Absinthe.Schema.Notation

  object :user_type do
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

  input_object :user_input_type do
    field :login, non_null(:string)
    field :password, non_null(:string)
    field :email, non_null(:string)
    field :name, non_null(:string)
    field :surname, :string
    field :age, :integer
    field :sex, :string
    field :city, :string
  end
end
