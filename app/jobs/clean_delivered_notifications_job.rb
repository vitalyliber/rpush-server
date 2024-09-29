class CleanDeliveredNotificationsJob < ApplicationJob
  sidekiq_options retry: 0
  queue_as :default

  def perform
    handle_exceptions do
      Rpush::Fcm::Notification.where(delivered: true).delete_all
      Rpush::Fcm::Notification.where(failed: true).delete_all
      Rpush::Apnsp8::Notification.where(delivered: true).delete_all
      Rpush::Apnsp8::Notification.where(failed: true).delete_all
    end
  end
end
