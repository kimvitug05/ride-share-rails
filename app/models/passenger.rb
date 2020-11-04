class Passenger < ApplicationRecord
  has_many :trips

  def total_cost
    return 0 if self.trips.empty?

    return (self.trips.sum { |trip| trip.cost.to_f }) / 100
  end
end
