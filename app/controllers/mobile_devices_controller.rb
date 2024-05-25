class MobileDevicesController < ApplicationController
  def index
    @mobile_user = MobileUser.find_by(mobile_access: @current_app, external_key: params[:external_key], environment: :production)

    render json: @mobile_user.present? ? @mobile_user.mobile_devices : []
  end

  def create
    mobile_device =
        MobileDevice.find_by(mobile_device_params) ||
            MobileDevice.new(mobile_device_params)
    mobile_device.mobile_user = MobileUser.find_or_create_by!(mobile_users_params)
    if mobile_device.save
      render json: {}
    else
      render json: { errors: mobile_device.errors.full_messages }, status: 400
    end
  end

  def destroy
    MobileDevice
        .find_by(device_token: params[:id])
        .try(:delete)
    render json: {}
  end

  private

  def restrict_access
    authenticate_or_request_with_http_token do |token, _options|
      token.present? && (@current_app = MobileAccess.find_by(client_token: token) || MobileAccess.find_by(server_token: token))
    end
  end

  def mobile_device_params
    params
      .require(:mobile_device)
      .permit(:device_type, :device_token)
  end

  def mobile_users_params
    params
      .require(:mobile_user)
      .permit(:external_key, :environment)
      .try {|hash| hash.merge(mobile_access: current_app)}
      .try {|hash| hash[:external_key] ? hash : hash.merge(external_key: '')}
  end
end
