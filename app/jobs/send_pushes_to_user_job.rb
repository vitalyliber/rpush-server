class SendPushesToUserJob < ApplicationJob
  sidekiq_options retry: 0
  queue_as :default

  def perform(mobile_user_id, notification)
    handle_exceptions do
      MobileUser.find(mobile_user_id).send_pushes(JSON.parse(notification, symbolize_names: true))
    end
  end
end
