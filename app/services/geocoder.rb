# frozen_string_literal: true

class Geocoder
  attr_reader :client

  def initialize
    credentials = SmartyStreets::StaticCredentials.new(ENV['SMARTY_STREETS_AUTH_ID'], ENV['SMARTY_STREETS_AUTH_TOKEN'])

    @client = SmartyStreets::ClientBuilder.new(credentials).build_us_street_api_client
  end

  def geocode_batch(addresses)
    batch = SmartyStreets::Batch.new

    build_batch(addresses, batch)

    client.send_batch(batch)

    process_results(batch)
  end

private

  def build_batch(addresses, batch)
    addresses.each do |address|
      facets_combined = "#{address[:street_address]}, #{address[:city]}, #{address[:state]} #{address[:zip]}"
      lookup = SmartyStreets::USStreet::Lookup.new(facets_combined)
      lookup.input_id = facets_combined
      batch.add(lookup)
    end
  end

  def process_results(batch)
    addresses = {}

    batch.each do |lookup|
      candidates = lookup.result

      candidate = candidates.first

      if candidate
        metadata = candidate.metadata
        addresses[candidate.input_id] = { lat: metadata.latitude, lon: metadata.longitude }
      else
        break
      end
    end

    addresses
  end
end
