require 'geocoder/results/base'

module Geocoder::Result
  class AmazonLocationServiceV2 < Base
    def initialize(result)
      @result = result
      @address_data = result.address
      @position = result.position
      super
    end

    def coordinates
      [@position[1], @position[0]]
    end

    def address
      @result.title
    end

    def neighborhood
      @address_data.district if @address_data.respond_to?(:district)
    end

    def route
      @address_data.street if @address_data.respond_to?(:street)
    end

    def city
      @address_data.locality if @address_data.respond_to?(:locality)
    end

    def state
      @address_data.region&.name if @address_data.respond_to?(:region)
    end

    def state_code
      @address_data.region&.code if @address_data.respond_to?(:region)
    end

    def province
      state
    end

    def province_code
      state_code
    end

    def postal_code
      @address_data.postal_code if @address_data.respond_to?(:postal_code)
    end

    def country
      @address_data.country&.name if @address_data.respond_to?(:country)
    end

    def country_code
      @address_data.country&.code_3 if @address_data.respond_to?(:country)
    end

    def place_id
      @result.place_id if @result.respond_to?(:place_id)
    end
  end
end
