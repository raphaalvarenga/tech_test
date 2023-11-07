defmodule YourApp.Repo.Migrations.AddMarketToBookings do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :market, :string, null: true
    end
  end

  def down do
    alter table(:bookings) do
      remove :market
    end
  end
end