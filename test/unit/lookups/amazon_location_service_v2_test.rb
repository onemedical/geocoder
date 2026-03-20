# encoding: utf-8
require 'test_helper'

class AmazonLocationServiceV2Test < GeocoderTestCase

  def setup
    super
    Geocoder.configure(lookup: :amazon_location_service_v2)
  end

  def test_amazon_location_service_v2_geocoding
    result = Geocoder.search("Madison Square Garden, New York, NY").first
    assert_equal "Madison Ave, Staten Island, NY, 10314, USA", result.address
    assert_equal "Staten Island", result.city
    assert_equal "New York", result.state
    assert_equal "NY", result.state_code
    assert_equal "10314", result.postal_code
    assert_equal "United States", result.country
    assert_equal "USA", result.country_code
    assert_equal "Graniteville", result.neighborhood
    assert_equal "Madison Ave", result.route
  end

  def test_amazon_location_service_v2_reverse_geocoding
    result = Geocoder.search([45.423733, -75.676333]).first
    assert_equal "Madison Ave, Staten Island, NY, 10314, USA", result.address
    assert_equal "Staten Island", result.city
    assert_equal "New York", result.state
    assert_equal "NY", result.state_code
    assert_equal "10314", result.postal_code
    assert_equal "United States", result.country
    assert_equal "USA", result.country_code
  end

  def test_amazon_location_service_v2_place_id
    result = Geocoder.search("Madison Square Garden, New York, NY").first
    assert_equal "AQABAFMAf5Cj6ApTW9YHMA3COqc3G1_dNHr1qtFl-W36hTyQd_Jw0f-t-7oaBxmbWd9vNecT3rIiH6O6DJ36qPk7seUIuIp8tOOZDoQnuweFUE5fHjvl15sTbn1PREQwp_66LjvkkubhQ3seXgBrCMZT3rt_dBzubg", result.place_id
  end

  def test_amazon_location_service_v2_coordinates
    result = Geocoder.search("Madison Square Garden, New York, NY").first
    assert_equal [40.61681535865544, -74.15434739412053], result.coordinates
  end

  def test_amazon_location_service_v2_no_results
    results = Geocoder.search("no results")
    assert_equal [], results
  end
end
