class PushNotificationsController < ApplicationController
  def create
    mobile_user = MobileUser.find_or_create_by!(mobile_users_params)
    mobile_user.send_pushes(
        title: message_params[:title],
        message: message_params[:message],
        device_type: params[:device_type] || 'all'
    )
    render json: {}
  end

  private

  def message_params
    params.require(:message).permit(
        :title,
        :message
    )
  end

  def mobile_users_params
    params
        .require(:mobile_user)
        .permit(:external_key, :environment)
        .try {|hash| hash.merge(mobile_access: current_app)}
  end
end
