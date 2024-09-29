class MobileUser < ApplicationRecord
  # TODO do we still need the environment field?
  enum environment: { development: 0, production: 1 }
  validates :external_key, :environment, :mobile_access, presence: true
  validates_uniqueness_of :external_key, scope: %i[environment mobile_access]
  has_many :mobile_devices
  belongs_to :mobile_access

  def send_pushes(title: '', message: '', device_type: '', data: {}, data_notification: {}, content_available: false)
    if device_type == "android"
      tokens = self.mobile_devices.pluck(:device_token)
      PushNotificationService.send_pushes(tokens: tokens, title: title, message: message, data: data, data_notification: data_notification, content_available: content_available)
      return
    end

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
