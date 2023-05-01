class PushNotificationsController < ApplicationController
  def create
    send_message = lambda do |mobile_user|
      mobile_user.send_pushes(
        title: message_params[:title],
        message: message_params[:message],
        device_type: params[:device_type] || 'all',
        data: message_params[:data].to_json,
        data_notification: message_params[:data_notification].to_json
      )
    end
    if params.dig(:mobile_user, :external_key).present?
      mobile_user = MobileUser.find_or_create_by!(mobile_users_params)
      send_message.call(mobile_user)
    else
      current_app.mobile_users.where(
        environment: params.dig(:mobile_user, :environment)
      ).find_each { |mobile_user| send_message.call(mobile_user) }
    end

    render json: {}
  end

  private

  # def message_params
  #   params.require(:message).permit(:title, :message, :data)
  # end
  def message_params
    params[:message]
  end

  def mobile_users_params
    params.require(:mobile_user).permit(:external_key, :environment)
      .try { |hash| hash.merge(mobile_access: current_app) }
  end
end
