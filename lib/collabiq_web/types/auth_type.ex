defmodule CollabiqWeb.AuthType do
  use Absinthe.Schema.Notation

  alias CollabiqWeb.Resolver

  object :login_result do
    field(:token, :string)
  end

  object :auth_mutation do
    field :login, :login_result do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolver.login/2)
    end
  end
end
