require "test_helper"

describe TripsController do
  before do
    @driver = Driver.create(
        {
            name: "Kim Vitug",
            vin: "FDSGB3245TERSD",
            available: true
        }
    )
    @passenger = Passenger.create(
        {
            name: "Sophie Messing",
            phone_num: "555-555-5555"
        }
    )
    @trip = Trip.create(
        {
            date: Date.today,
            rating: 4,
            cost: 1865,
            passenger_id: @passenger.id,
            driver_id: @driver.id
        }
    )
  end

  describe "show" do
    it "responds with success when showing an existing trip" do

      # Act
      get trip_path(@trip.id)

      # Assert
      must_respond_with :success
    end

    it "responds with 404 with an invalid trip id" do
      # Arrange
      invalid_id = -1

      # Act
      get trip_path(invalid_id)

      # Assert
      must_respond_with :not_found
    end
  end

  describe "create" do
    it "can create a new trip with valid information accurately, and redirect" do
      driver = Driver.create(
          name: "Kim Vitug",
          vin: "FDSGB3245TERSD",
          available: true
      )
      passenger = Passenger.create(
          name: "Sophie Messing",
          phone_num: "555-555-5555"
      )

      trip_info = {
          trip: {
              driver_id: driver.id,
              passenger_id: passenger.id,
              date: Date.today,
              cost: 2342,
          }
      }

      expect {
        post passenger_trips_path(passenger_id: passenger.id), params: trip_info
      }.must_differ "Trip.count", 1

      new_trip = Trip.find_by(passenger_id: passenger.id)
      first_driver = Driver.first

      expect(new_trip.date).must_equal Date.today
      expect(new_trip.cost).must_be_kind_of Integer
      expect(new_trip.rating).must_be_nil
      expect(new_trip.driver_id).must_equal first_driver.id

      must_respond_with :redirect
    end

    it "does not create a trip if the form data violates Trip validations, and responds with bad request" do
      # new_trip = Trip.create(date: Date.today)
      #
      # expect{
      #   post passengers_path(new_trip)
      # }.wont_change "Passenger.count"
      #
      # # Assert
      # # Check that the controller redirects
      # must_respond_with :bad_request
    end
  end

  describe "edit" do
    # Your tests go here
  end

  describe "update" do
    # Your tests go here
  end

  describe "destroy" do
    @passenger = Passenger.create(
        name: 'Kim Vitug',
        phone_num: '555-555-5555'
    )

    @driver = Driver.create(
        name: 'Valentine Messing',
        vin: 'DGASDFW32432',
        available: true
    )

    @trip_to_delete = Trip.create(
        passenger_id: @passenger.id,
        driver_id: @driver.id,
        date: Date.today,
        cost: 1234,
        rating: nil
    )

    it "destroys the trip instance in db when trip exists, then redirects" do
      trip = Trip.first

      expect{
        delete trip_path(id: trip.id)
      }.must_differ "Trip.count", -1
    end

    it "does not change the db when the trip does not exist, then responds with not found" do
      expect{
        delete trip_path(id: -1)
      }.wont_change "Trip.count"

      must_respond_with :not_found
    end
  end
end
