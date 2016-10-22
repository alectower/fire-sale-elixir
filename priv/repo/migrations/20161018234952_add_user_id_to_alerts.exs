defmodule FireSale.Repo.Migrations.AddUserIdToAlerts do
  use Ecto.Migration

  def change do
    alter table(:alert) do
      add :user_id, :integer
    end
  end
end
