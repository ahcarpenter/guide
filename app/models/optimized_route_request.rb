# frozen_string_literal: true

class OptimizedRouteRequest < ApplicationRecord
  attr_accessor :addresses, :geo_coordinates

  validates_uniqueness_of :hashed_request
  validates_presence_of :request
  validate :format_of_provider_id
  validate :format_of_addresses
  validate :format_of_geo_coordinates

  def geo_coordinates
    JSON.parse(parsed_request[:geo_coordinates])
  end

  def addresses
    @addresses ||= Geocoder.new.geocode_batch(JSON.parse(parsed_request[:addresses]).map(&:with_indifferent_access))
  end

  private

  def parsed_request
    @parsed_request ||= JSON.parse(request).with_indifferent_access
  end

  def format_of_provider_id
    errors.add(:provider_id, 'invalid') unless UUID.validate(provider_id)
  end

  def format_of_geo_coordinates
    lat, lon = geo_coordinates

    valid = lat.is_a?(Float) && lon.is_a?(Float) && (-90..90).include?(lat) && (-180..180).include?(lon)

    errors.add(:geo_coordinates, 'invalid') unless valid
  end

  def format_of_addresses
    if addresses.empty?
      errors.add(:addresses, 'contains at least one invalid address')
    end # this will be empty if any addresses weren't able to be geocoded, and in turn, were invalid
  end
end
