defmodule FireSale.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :email, :string
      add :encrypted_password, :string

      timestamps()
    end
  end
end
