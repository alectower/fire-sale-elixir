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
  def changeset(alert, params \\ %{}) do
    params = Map.put(
      params,
      "price",
      convert_price(params["price"])
    )

    alert
    |> cast(params, [:symbol, :price, :user_id])
    |> validate_required([:symbol, :price, :user_id])
  end

  defp convert_price(price) do
    case price do
      nil -> nil
      "" -> nil
      p when is_integer(p) -> p * 100
      p ->
        {c_price, p} = Float.parse(p)

        c_price * 100
        |> :erlang.float_to_list([{:decimals, 0}])
        |> :erlang.list_to_integer
    end
  end
end
