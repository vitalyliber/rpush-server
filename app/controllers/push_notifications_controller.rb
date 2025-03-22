class PushNotificationsController < ApplicationController
  def create
    notification = {
      title: message_params[:title],
      message: message_params[:message],
      device_type: params[:device_type] || 'all',
      data: message_params[:data]&.to_unsafe_h || {},
      data_notification: message_params[:data_notification]&.to_unsafe_h || {},
      content_available: params[:content_available]
    }

    if params.dig(:mobile_user, :external_key).present?
      mobile_user = MobileUser.find_or_create_by!(mobile_users_params)
      SendPushesToUserJob.perform_later(mobile_user.id, notification.to_json)
    elsif message_params[:topic].present?
      PushNotificationService.send_pushes(
        tokens: nil,
        **clean_notification(notification),
        topic: message_params[:topic]
      )
    else
      SendPushesToEveryoneFirebaseJob.perform_later(current_app.id, notification.to_json) if params[:device_type] === "android"
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

  def clean_notification(notification)
    notification.slice(*[:tokens, :title, :message, :data, :data_notification, :content_available, :topic])
  end
end
