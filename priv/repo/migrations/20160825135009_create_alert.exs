defmodule FireSale.Repo.Migrations.CreateAlert do
  use Ecto.Migration

  def change do
    create table(:alert) do
      add :symbol, :string
      add :price, :integer

      timestamps()
    end

  end
end
