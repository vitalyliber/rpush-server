class HomeController < ApplicationController
  # skip_before_action :restrict_access, only: [:index]
  before_action :restrict_access

  def index
  end

  def restrict_access
    if ENV['DEVELOPER_USERNAME'] && ENV['DEVELOPER_PASSWORD']
      authenticate_or_request_with_http_basic('Basic authorization') do |username, password|
        username == ENV['DEVELOPER_USERNAME'] && password == ENV['DEVELOPER_PASSWORD']
      end
    end
  end
end
