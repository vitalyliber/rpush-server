class PushNotificationService
  def self.send_pushes(tokens: [], title: '', message: '', data: {}, data_notification: {}, content_available: false)
    tokens.each_slice(500) do |tokens_slice|
      notification = {
        tokens: tokens_slice,
        notification: {
          title: title,
          body: message,
        },
        android: {
          "priority": "high",
          notification: {
            channelId: "default"
          }.merge!(data_notification.slice(*[:channelId, :title, :body, :icon, :color, :sound, :tag, :click_action]))
        },
        apns: {
          payload: {
            aps: {
              'content-available': content_available ? 1  : 0,
            },
          },
        },
        data: data.transform_values(&:to_s)
      }

      response = `node ./fcm_send.js '#{notification.to_json}' '#{Rpush::Fcm::App.last.json_key}'`

      if response.include?("sent successfully")
        Rails.logger.info("Message sent successfully: #{tokens.count}")
      else
        Rails.logger.error("Sending error: #{tokens.count} #{response}")
      end
    end
  end
end
