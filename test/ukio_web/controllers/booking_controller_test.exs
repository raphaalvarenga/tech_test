defmodule UkioWeb.BookingControllerTest do
  use UkioWeb.ConnCase, async: true

  import Ukio.ApartmentsFixtures

  @create_attrs %{
    apartment_id: 42,
    check_in: "2023-03-26",
    check_out: "2023-03-26",
    market: "Earth"
  }

    @create_attrs_mars %{
    apartment_id: 42,
    check_in: "2023-03-26",
    check_out: "2023-03-26",
    market: "Mars"
  }

  @invalid_attrs %{
    apartment_id: 1,
    check_in: nil,
    check_out: nil,
    deposit: nil,
    monthly_rent: nil,
    utilities: nil,
    market: nil
  }

  setup %{conn: conn} do
    {:ok,
     conn: put_req_header(conn, "accept", "application/json"), apartment: apartment_fixture()}
  end

  describe "create booking" do
    test "renders booking when data is valid", %{conn: conn, apartment: apartment} do
      b = Map.merge(@create_attrs, %{apartment_id: apartment.id})
      conn = post(conn, ~p"/api/bookings", booking: b)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/bookings/#{id}")

      assert %{
               "id" => ^id,
               "check_in" => "2023-03-26",
               "check_out" => "2023-03-26",
               "deposit" => 100_000,
               "monthly_rent" => 250_000,
               "utilities" => 20000
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, apartment: apartment} do
      b = Map.merge(@invalid_attrs, %{apartment_id: apartment.id})
      conn = post(conn, ~p"/api/bookings", booking: b)
      assert json_response(conn, 400)["errors"] != %{}
    end

    test "returns 401 when the apartment is unavailable for the selected dates", %{conn: conn, apartment: apartment} do
      # Book the apartment for the selected dates
      b = Map.merge(@create_attrs, %{apartment_id: apartment.id})
      conn = post(conn, ~p"/api/bookings", booking: b)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = post(conn, ~p"/api/bookings", booking: b)
      assert conn.status == 401
    end

     test "returns 401 when the apartment is unavailable for some days in the range - upper limit", %{conn: conn, apartment: apartment} do
      # Book the apartment for the selected dates
      b = Map.merge(@create_attrs, %{apartment_id: apartment.id})
      conn = post(conn, ~p"/api/bookings", booking: b)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conflict_attrs = %{
        apartment_id: 42,
        check_in:  "2023-03-26",
        check_out: "2023-03-30",
        market: "Earth"
      }
      

      b = Map.merge(conflict_attrs, %{apartment_id: apartment.id})
      conn = post(conn, ~p"/api/bookings", booking: b)
      assert conn.status == 401
    end

    test "returns 401 when the apartment is unavailable for some days in the range - lower limit", %{conn: conn, apartment: apartment} do
      # Book the apartment for the selected dates
      b = Map.merge(@create_attrs, %{apartment_id: apartment.id})
      conn = post(conn, ~p"/api/bookings", booking: b)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conflict_attrs = %{
        apartment_id: 42,
        check_in: "2023-03-10",
        check_out: "2023-03-26",
        market: "Earth"
      }
      

      b = Map.merge(conflict_attrs, %{apartment_id: apartment.id})
      conn = post(conn, ~p"/api/bookings", booking: b)
      assert conn.status == 401
    end

     test "returns 200 when the apartment is booked in available dates", %{conn: conn, apartment: apartment} do
      # Book the apartment for the selected dates
      b = Map.merge(@create_attrs, %{apartment_id: apartment.id})
      conn = post(conn, ~p"/api/bookings", booking: b)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      second_booking_attrs = %{
        apartment_id: 42,
        check_in: "2023-03-10",
        check_out: "2023-03-12",
        market: "Earth"
      }
      

      b = Map.merge(second_booking_attrs, %{apartment_id: apartment.id})
      conn = post(conn, ~p"/api/bookings", booking: b)
      assert conn.status == 201
    end

    test "create a booking in mars market", %{conn: conn, apartment: apartment} do
      # Book the apartment for the selected dates
      b = Map.merge(@create_attrs_mars, %{apartment_id: apartment.id})
      conn = post(conn, ~p"/api/bookings", booking: b)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/bookings/#{id}")

      assert %{
               "id" => ^id,
               "check_in" => "2023-03-26",
               "check_out" => "2023-03-26",
               "deposit" => 250_000,
               "monthly_rent" => 250_000,
               "utilities" => 210,
               "market" => "Mars"
             } = json_response(conn, 200)["data"]
    end
    
  end
    

  defp create_booking(_) do
    booking = booking_fixture()
    %{booking: booking}
  end
end