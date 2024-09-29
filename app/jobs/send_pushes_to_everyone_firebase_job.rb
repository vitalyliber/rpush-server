class SendPushesToEveryoneFirebaseJob < ApplicationJob
  sidekiq_options retry: 0
  queue_as :default

  def perform(app_id, notification)
    handle_exceptions(raise_error: false) do
      send_telegram_message("The worker started the processing of sending push notifications.")
      index = 1

      MobileAccess.find(app_id).mobile_users.where(
        environment: "production"
      ).find_in_batches(batch_size: 1000) do |mobile_users_batch|
        ids = mobile_users_batch.pluck(:id)

        tokens = MobileDevice.where(mobile_user_id: ids, device_type: :android).pluck(:device_token)

        PushNotificationService.send_pushes(tokens: tokens, **parse_notification(notification))

        send_telegram_message("The worker handled the #{index} batch (#{tokens.count} tokens in a collection)")

        index += 1
      end
    end
  end

  def parse_notification(notification)
    parsed_notification = JSON.parse(notification, symbolize_names: true)
    parsed_notification.slice(*[:tokens, :title, :message, :data, :data_notification, :content_available])
  end
end
