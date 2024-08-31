class SendPushesToEveryoneJob < ApplicationJob
  sidekiq_options retry: 0
  queue_as :default

  def perform(app_id, notification)
    handle_exceptions(raise_error: false) do
      send_telegram_message("The worker started the processing of sending push notifications.")
      index = 1

      MobileAccess.find(app_id).mobile_users.where(
        environment: "production"
      ).find_in_batches(batch_size: 1000) do |mobile_users|

        # if index < 7
        #   index += 1
        #   next
        # end

        handle_exceptions(raise_error: false) do
          mobile_users.each do |mobile_user|
            handle_exceptions(raise_error: false) do
              mobile_user.send_pushes(JSON.parse(notification, symbolize_names: true))
            end
          end
        end
        send_telegram_message("The worker handled the #{index} batch (1000 mobile users in a collection)")

        index += 1
      end
    end
  end
end
