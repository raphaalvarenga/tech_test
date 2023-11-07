defmodule UkioWeb.BookingController do
  use UkioWeb, :controller

  alias Ukio.Apartments
  alias Ukio.Apartments.Booking
  alias Ukio.Bookings.Handlers.BookingCreator

  action_fallback UkioWeb.FallbackController

def create(conn, %{"booking" => booking_params}) do
  case BookingCreator.create(booking_params) do
    {:ok, %Booking{} = booking} ->
      conn
      |> put_status(:created)
      |> render(:show, booking: booking)

    :unavailable ->
      conn
      |> put_status(:unauthorized) 
      |> json(%{error: "Booking is unavailable for the selected dates"})

    :bad_request ->
      conn
      |> put_status(:bad_request)
      |> json(%{error: "Invalid request"})
  end
end

  def show(conn, %{"id" => id}) do
    booking = Apartments.get_booking!(id)
    render(conn, :show, booking: booking)
  end
end
