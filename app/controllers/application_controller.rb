class ApplicationController < ActionController::Base
  include ActionController::HttpAuthentication::Token
  include ::ErrorHandling
  skip_before_action :verify_authenticity_token
  before_action :restrict_access
  rescue_from ActiveRecord::RecordNotFound, with: :error_to_json_response
  rescue_from ActiveRecord::RecordInvalid, with: :error_to_json_response

  private

  def error_to_json_response(error)
    render json: { :error => error.message }, :status => :not_found
  end

  def fetch_access
    token, _options = token_and_options(request)
    @current_app = MobileAccess.find_by(server_token: token)
  end

  def restrict_access
    authenticate_or_request_with_http_token do |token, _options|
      token.present? && (@current_app = MobileAccess.find_by(server_token: token))
    end
  end

  def current_app
    @current_app
  end
end
