class PushNotificationsController < ApplicationController
  def create
    notification = {
      title: message_params[:title],
      message: message_params[:message],
      device_type: params[:device_type] || 'all',
      data: message_params[:data]&.to_unsafe_h || {},
      data_notification: message_params[:data_notification]&.to_unsafe_h || {}
    }

    if params.dig(:mobile_user, :external_key).present?
      mobile_user = MobileUser.find_or_create_by!(mobile_users_params)
      mobile_user.send_pushes(notification)
    else
      current_app.mobile_users.where(
        environment: "production"
      ).find_each { |mobile_user| mobile_user.send_pushes(notification) }
    end

    render json: {}
  end

  private

  def message_params
    params[:message]
  end

  def mobile_users_params
    params.require(:mobile_user).permit(:external_key)
      .try { |hash| hash.merge(mobile_access: current_app, environment: "production") }
  end
end
