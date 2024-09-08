class MobileUser < ApplicationRecord
  # TODO do we still need the environment field?
  enum environment: { development: 0, production: 1 }
  validates :external_key, :environment, :mobile_access, presence: true
  validates_uniqueness_of :external_key, scope: %i[environment mobile_access]
  has_many :mobile_devices
  belongs_to :mobile_access

  def send_pushes(title: '', message: '', device_type: '', data: {}, data_notification: {}, content_available: false)
    self.mobile_devices.each do |device|

      callback = -> (msg) { device.delete if msg.include?("Device token is invalid") }

      handle_exceptions(true, callback) do
        if device.ios? && %w[all ios].include?(device_type)
          n = Rpush::Apnsp8::Notification.new
          n.app = apnsp8
          n.device_token = device.device_token
          n.alert = { "title": title, "body": message }
          n.sound = 'default'
          n.data = data
          n.save!
        end

        if device.android? && %w[all android].include?(device_type)
          notification = {
            token: device.device_token,
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
            Rails.logger.info("Message sent successfully: #{self.external_key} #{device.device_token}")
          else
            Rails.logger.error("Sending error: #{self.external_key} #{device.device_token} #{response}")
          end
        end
      end
    end
  end

  def apnsp8
    @apnsp8_app ||= Rpush::Apnsp8::App.find_by(
      name: mobile_access.app_name,
      environment: environment
    )
  end

  def firebase
    @firebase_app ||= Rpush::Fcm::App.find_by_name(mobile_access.app_name)
  end
end
