class PushNotificationService
  def self.send_pushes(tokens: [], title: '', message: '', data: {}, data_notification: {}, content_available: false, topic: nil)
    send = ->(tokens_slice) do
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
        data: data.transform_values(&:to_s),
        topic: topic
      }.compact

      response = `node ./fcm_send.js '#{notification.to_json}' '#{Rpush::Fcm::App.last.json_key}'`

      p(response) if Rails.env.development?

      topic_text = topic ? "to topic #{topic}" : ""

      if response.include?("sent successfully")
        Rails.logger.info("Message sent successfully: #{tokens&.count || topic_text}")
      else
        Rails.logger.error("Sending error: #{tokens&.count || topic_text} #{response}")
      end
    end

    send.call(nil) if topic

    tokens&.each_slice(500) do |tokens_slice|
      send.call(tokens_slice)
    end
  end
end
