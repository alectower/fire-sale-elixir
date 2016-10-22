defmodule FireSale.Alert do
  use FireSale.Web, :model

  schema "alert" do
    field :symbol, :string
    field :price, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    new_params = params

    if !Enum.empty?(params) do
      price = convert_price(params)
      new_params = Map.put(new_params, "price", price)
    end

    struct
    |> cast(new_params, [:symbol, :price])
  end

  def convert_price(params) do
    price_param = Map.get(params, "price")

    {price, _} = Float.parse(price_param)

    price * 100
    |> :erlang.float_to_list([{:decimals, 0}])
    |> :erlang.list_to_integer
  end
end
