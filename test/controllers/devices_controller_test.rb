require 'test_helper'

class DevicesControllerTest < ActionDispatch::IntegrationTest
  test "should get get_ip_address" do
    get devices_get_ip_address_url
    assert_response :success
  end

end
