defmodule FireSale.User do
  use FireSale.Web, :model

  schema "user" do
    field :email, :string
    field :password, :string, virtual: true
    field :encrypted_password, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(email), [])
    |> validate_format(:email, ~r/.*@.*\..*/)
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 8)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
