defmodule FireSale.AlertTest do
  use FireSale.ModelCase

  alias FireSale.Alert

  @valid_attrs %{price: 42, symbol: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Alert.changeset(%Alert{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Alert.changeset(%Alert{}, @invalid_attrs)
    refute changeset.valid?
  end
end
