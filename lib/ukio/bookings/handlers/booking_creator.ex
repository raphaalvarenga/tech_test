defmodule Ukio.Bookings.Handlers.BookingCreator do
  alias Ukio.Apartments

  def create(%{"check_in" => check_in, "check_out" => check_out, "apartment_id" => apartment_id} = params) do
    case is_apartment_available(apartment_id, check_in, check_out) do
      :ok ->
        with a <- Apartments.get_apartment!(apartment_id),
         b <- generate_booking_data(a, check_in, check_out) do
          Apartments.create_booking(b)
        end

      :unavailable ->
        :unavailable
    end
  end

  defp generate_booking_data(apartment, check_in, check_out) do
    %{
      apartment_id: apartment.id,
      check_in: check_in,
      check_out: check_out,
      monthly_rent: apartment.monthly_price,
      utilities: 20_000,
      deposit: 100_000
    }
  end

  defp is_apartment_available(apartment_id, check_in, check_out) do
    existing_booking =
      Apartments.get_existing_booking(apartment_id, check_in, check_out)
    case existing_booking do
      0 -> :ok
      _ -> :unavailable
    end
  end
  

end
