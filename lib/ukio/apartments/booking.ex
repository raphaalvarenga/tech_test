defmodule Ukio.Apartments.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ukio.Apartments.Apartment

  schema "bookings" do
    belongs_to(:apartment, Apartment)

    field :check_in, :date
    field :check_out, :date
    field :deposit, :integer
    field :monthly_rent, :integer
    field :utilities, :integer
    field :market, :string
    timestamps()
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [:check_in, :check_out, :apartment_id, :monthly_rent, :deposit, :utilities, :market])
    |> validate_required([
      :check_in,
      :check_out,
      :apartment_id,
      :monthly_rent,
      :deposit,
      :utilities,
      :market
    ])
  end
end
