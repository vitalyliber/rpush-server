class AccessesController < ApplicationController
  def index
    render json: @current_app.as_json(only: %i[id app_name created_at updated_at])
  end
end
