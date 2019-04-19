ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def server_access_headers
    { Authorization: "Bearer #{mobile_accesses(:one).server_token}" }
  end

  def client_access_headers
    { Authorization: "Bearer #{mobile_accesses(:one).client_token}" }
  end

  def body_json
    JSON.parse body
  end
end
