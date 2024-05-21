class MobileUser < ApplicationRecord
  # TODO do we still need the environment field?
  enum environment: { development: 0, production: 1 }
  validates :external_key, :environment, :mobile_access, presence: true
  validates_uniqueness_of :external_key, scope: %i[environment mobile_access]
  has_many :mobile_devices
  belongs_to :mobile_access

  def send_pushes(title: '', message: '', device_type: '', data: {}, data_notification: {})
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
          n = Rpush::Gcm::Notification.new
          n.app = firebase
          n.registration_ids = [device.device_token]
          n.data = { body: message,
                     title: title,
                     data: data,
                     message: message
          }
          n.priority = 'high' # Optional, can be either 'normal' or 'high'
          # Disable this field when need to debug on iOS simulator
          # It needs to wake up the data-only apps on iOS
          n.content_available = true
          # Optional notification payload. See the reference below for more keys you can use!

          notification = {
            body: message,
            title: title,
            icon: 'ic_notification',
          }

          notification.merge!(data_notification)

          n.notification = notification
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
    @firebase_app ||= Rpush::Gcm::App.find_by_name(mobile_access.app_name)
  end
end
