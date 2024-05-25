class AccessesController < ApplicationController
  skip_before_action :restrict_access
  before_action :fetch_access
  def index
    render json: @current_app.present? ? @current_app.as_json(only: %i[id app_name created_at updated_at]) : {}
  end
end
