defmodule Ukio.Bookings.Handlers.BookingCreator do
  alias Ukio.Apartments

  def create(%{"check_in" => check_in, "check_out" => check_out, "apartment_id" => apartment_id, "market" => market} = params) do
    case is_apartment_available(apartment_id, check_in, check_out) do
      :ok ->
        with a <- Apartments.get_apartment!(apartment_id),
         b <- generate_booking_data(a, check_in, check_out, market) do
          Apartments.create_booking(b)
        end

      :unavailable ->
        :unavailable
    end
  end

defp generate_booking_data(apartment, check_in, check_out, market) do
  case market do
    "Mars" ->
      %{
        apartment_id: apartment.id,
        check_in: check_in,
        check_out: check_out,
        monthly_rent: apartment.monthly_price,
        deposit: apartment.monthly_price,  
        utilities: calculate_utilities(apartment.square_meters),
        market: market
      }
    _ ->
      %{
        apartment_id: apartment.id,
        check_in: check_in,
        check_out: check_out,
        monthly_rent: apartment.monthly_price,
        deposit: 100_000,  
        utilities: 20_000,
        market: market
      }
  end
end

  defp is_apartment_available(apartment_id, check_in, check_out) do
    existing_booking =
      Apartments.get_existing_booking(apartment_id, check_in, check_out)
    case existing_booking do
      0 -> :ok
      _ -> :unavailable
    end
  end

  defp calculate_utilities(square_meters) when is_integer(square_meters) and square_meters >= 0 do
  utility_rate_per_square_meter = 5  
  utilities = square_meters * utility_rate_per_square_meter

  utilities
end

end
