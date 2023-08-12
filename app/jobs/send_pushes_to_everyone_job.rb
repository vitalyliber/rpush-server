class SendPushesToEveryoneJob < ApplicationJob
  queue_as :default

  def perform(current_app, notification)
    current_app.mobile_users.where(
      environment: "production"
    ).find_each(batch_size: 1000) { |mobile_user| mobile_user.send_pushes(notification) }
  end
end
