defmodule Ukio.ApartmentsTest do
  use Ukio.DataCase

  alias Ukio.Apartments

  describe "apartments" do
    alias Ukio.Apartments.Apartment

    import Ukio.ApartmentsFixtures

    @invalid_attrs %{
      address: nil,
      monthly_price: nil,
      name: nil,
      square_meters: nil,
      zip_code: nil
    }

    test "list_apartments/0 returns all apartments" do
      apartment_fixture()
      assert length(Apartments.list_apartments()) == 1
    end

    test "get_apartment!/1 returns the apartment with given id" do
      apartment = apartment_fixture()
      assert Apartments.get_apartment!(apartment.id) == apartment
    end

    test "create_apartment/1 with valid data creates a apartment" do
      valid_attrs = %{
        address: "some address",
        monthly_price: 42,
        name: "some name",
        square_meters: 42,
        zip_code: "some zip_code"
      }

      assert {:ok, %Apartment{} = apartment} = Apartments.create_apartment(valid_attrs)
      assert apartment.address == "some address"
      assert apartment.monthly_price == 42
      assert apartment.name == "some name"
      assert apartment.square_meters == 42
      assert apartment.zip_code == "some zip_code"
    end

    test "create_apartment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Apartments.create_apartment(@invalid_attrs)
    end

    test "update_apartment/2 with valid data updates the apartment" do
      apartment = apartment_fixture()

      update_attrs = %{
        address: "some updated address",
        monthly_price: 43,
        name: "some updated name",
        square_meters: 43,
        zip_code: "some updated zip_code"
      }

      assert {:ok, %Apartment{} = apartment} =
               Apartments.update_apartment(apartment, update_attrs)

      assert apartment.address == "some updated address"
      assert apartment.monthly_price == 43
      assert apartment.name == "some updated name"
      assert apartment.square_meters == 43
      assert apartment.zip_code == "some updated zip_code"
    end

    test "update_apartment/2 with invalid data returns error changeset" do
      apartment = apartment_fixture()
      assert {:error, %Ecto.Changeset{}} = Apartments.update_apartment(apartment, @invalid_attrs)
      assert apartment == Apartments.get_apartment!(apartment.id)
    end

    test "delete_apartment/1 deletes the apartment" do
      apartment = apartment_fixture()
      assert {:ok, %Apartment{}} = Apartments.delete_apartment(apartment)
      assert_raise Ecto.NoResultsError, fn -> Apartments.get_apartment!(apartment.id) end
    end

    test "change_apartment/1 returns a apartment changeset" do
      apartment = apartment_fixture()
      assert %Ecto.Changeset{} = Apartments.change_apartment(apartment)
    end
  end

  describe "bookings" do
    alias Ukio.Apartments.Booking

    import Ukio.ApartmentsFixtures

    @invalid_attrs %{
      apartment_id: nil,
      check_in: nil,
      check_out: nil,
      deposit: nil,
      monthly_rent: nil,
      utilities: nil
    }
    setup do
      %{apartment: apartment_fixture()}
    end

    test "list_bookings/0 returns all bookings" do
      booking = booking_fixture()
      assert Apartments.list_bookings() == [booking]
    end

    test "get_booking!/1 returns the booking with given id" do
      booking = booking_fixture()
      assert Apartments.get_booking!(booking.id) == booking
    end

    test "create_booking/1 with valid data creates a booking", %{apartment: apartment} do
      valid_attrs = %{
        apartment_id: apartment.id,
        check_in: ~D[2023-03-26],
        check_out: ~D[2023-03-26],
        deposit: 100_000,
        monthly_rent: 250_000,
        utilities: 20000
      }

      assert {:ok, %Booking{} = booking} = Apartments.create_booking(valid_attrs)
      assert booking.apartment_id == apartment.id
      assert booking.check_in == ~D[2023-03-26]
      assert booking.check_out == ~D[2023-03-26]
      assert booking.deposit == 100_000
      assert booking.monthly_rent == 250_000
      assert booking.utilities == 20000
    end

    test "create_booking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Apartments.create_booking(@invalid_attrs)
    end

    test "update_booking/2 with valid data updates the booking" do
      booking = booking_fixture()

      update_attrs = %{
        check_in: ~D[2023-03-27],
        check_out: ~D[2023-03-27]
      }

      assert {:ok, %Booking{} = booking} = Apartments.update_booking(booking, update_attrs)
      assert booking.check_in == ~D[2023-03-27]
      assert booking.check_out == ~D[2023-03-27]
    end

    test "update_booking/2 with invalid data returns error changeset" do
      booking = booking_fixture()
      assert {:error, %Ecto.Changeset{}} = Apartments.update_booking(booking, @invalid_attrs)
      assert booking == Apartments.get_booking!(booking.id)
    end

    test "delete_booking/1 deletes the booking" do
      booking = booking_fixture()
      assert {:ok, %Booking{}} = Apartments.delete_booking(booking)
      assert_raise Ecto.NoResultsError, fn -> Apartments.get_booking!(booking.id) end
    end

    test "change_booking/1 returns a booking changeset" do
      booking = booking_fixture()
      assert %Ecto.Changeset{} = Apartments.change_booking(booking)
    end

     test "get_existing_booking returns existing booking" do
      booking = booking_fixture()
      apartment = apartment_fixture()
      assert Apartments.get_existing_booking(apartment.id - 1,~D[2023-03-26],~D[2023-03-26]) == 1
    end

  end
end
