# frozen_string_literal: true

class OptimizeRoute
  include Dry::Transaction

  step :validate
  step :calculate_optimal_route
  step :process_results

  private

  def validate(optimized_route_request:)
    if optimized_route_request.valid?
      Success(geo_coordinates: optimized_route_request.geo_coordinates, addresses: optimized_route_request.addresses)
    else
      Failure(valid_input: false, error: optimized_route_request.errors.full_messages.join(', '))
    end
  end

  def calculate_optimal_route(geo_coordinates:, addresses:)
    routific = Routific.new
    origin_lat, origin_lon = geo_coordinates

    routific.set_vehicle(
      'driver',
      'start_location' => {
        'name' => "driver's origin",
        'lat' => origin_lat,
        'lng' => origin_lon
      }
    )
    set_visits(routific: routific, addresses: addresses)

    route = routific.get_route

    return Failure(valid_input: true, error: 'Routific service error') unless route.status == 'success'

    Success(addresses: addresses, route: route.vehicle_routes['driver'])
  end

  def process_results(addresses:, route:)
    route.shift

    optimized_route = route.each_with_object([]) do |waypoint, waypoints|
      address = waypoint.location_name

      waypoints << {
        street_address: address,
        coordinates: [addresses[address][:lat], addresses[address][:lon]]
      }
    end

    Success(optimized_route)
  end

  def set_visits(routific:, addresses:)
    addresses.each do |id, data|
      routific.set_visit(
        SecureRandom.uuid,
        'location' => {
          'name' => id,
          'lat' => data[:lat],
          'lng' => data[:lon]
        }
      )
    end
  end
end
