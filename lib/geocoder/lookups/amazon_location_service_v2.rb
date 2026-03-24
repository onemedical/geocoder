require 'geocoder/lookups/base'
require 'geocoder/results/amazon_location_service_v2'

module Geocoder::Lookup
  class AmazonLocationServiceV2 < Base
    def results(query)
      params = query.options.dup

      # Aws::ParamValidator raises ArgumentError on unexpected keys
      params.delete(:lookup)

      # Inherit language from configuration
      if configuration[:language]
        params[:language] = configuration[:language].to_s
      end

      resp = if query.reverse_geocode?
        client.reverse_geocode(
          params.merge(
            query_position: query.coordinates.reverse.map(&:to_f)
          )
        )
      else
        client.geocode(
          params.merge(query_text: query.text)
        )
      end

      resp.result_items
    rescue Aws::GeoPlaces::Errors::AccessDeniedException => err
      raise_error(Geocoder::RequestDenied, err.message) or
        Geocoder.log(:warn, "Amazon Location Service v2 access denied: #{err.message}")
      []
    rescue Aws::GeoPlaces::Errors::ThrottlingException => err
      raise_error(Geocoder::OverQueryLimitError, err.message) or
        Geocoder.log(:warn, "Amazon Location Service v2 rate limit exceeded: #{err.message}")
      []
    rescue Aws::GeoPlaces::Errors::ValidationException => err
      raise_error(Geocoder::InvalidRequest, err.message) or
        Geocoder.log(:warn, "Amazon Location Service v2 invalid request: #{err.message}")
      []
    rescue Aws::GeoPlaces::Errors::InternalServerException => err
      raise_error(Geocoder::ServiceUnavailable, err.message) or
        Geocoder.log(:warn, "Amazon Location Service v2 server error: #{err.message}")
      []
    rescue Aws::GeoPlaces::Errors::ServiceError => err
      raise_error(Geocoder::Error, err.message) or
        Geocoder.log(:warn, "Amazon Location Service v2 error: #{err.message}")
      []
    end

    private

    def client
      return @client if @client
      require_sdk
      keys = configuration.api_key
      if keys
        @client = Aws::GeoPlaces::Client.new(**{
          region: keys[:region],
          access_key_id: keys[:access_key_id],
          secret_access_key: keys[:secret_access_key]
        }.compact)
      else
        @client = Aws::GeoPlaces::Client.new
      end
    end

    def require_sdk
      begin
        require 'aws-sdk-geoplaces'
      rescue LoadError
        raise_error(Geocoder::ConfigurationError) ||
          Geocoder.log(
            :error,
            "Couldn't load the Amazon GeoPlaces SDK. " +
            "Install it with: gem install aws-sdk-geoplaces"
          )
      end
    end
  end
end
