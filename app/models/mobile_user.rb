class MobileUser < ApplicationRecord
  enum environment: { development: 0, production: 1 }
  validates :external_key, :environment, :mobile_access, presence: true
  validates_uniqueness_of :external_key, scope: %i[environment mobile_access]
  has_many :mobile_devices
  belongs_to :mobile_access
  # a1b59e5fed47773a0749ee6a0d704f4ae5ffbad6bdfc3a29485fc7dc3e25ecf3
  def send_pushes(title: '', message: '', device_type: 'all', data: {})

    self.mobile_devices.each do |device|

      if device.ios? && %w[all ios].include?(device_type)
        if mobile_access.apnsp8?
          n = Rpush::Apnsp8::Notification.new
          n.app =
              Rpush::Apnsp8::App.find_by(
                  name: mobile_access.app_name, environment: environment
              )
        else
          n = Rpush::Apns::Notification.new
          n.app =
              Rpush::Apns::App.find_by(
                  name: mobile_access.app_name, environment: environment
              )
        end
        n.device_token = device.device_token
        n.alert = { "title": title, "body": message }
        n.sound = 'default'
        n.data = JSON.parse(data)
        n.save!
      end
      if device.android? && %w[all android].include?(device_type)
        n = Rpush::Gcm::Notification.new
        n.app = Rpush::Gcm::App.find_by_name(mobile_access.app_name)
        n.registration_ids = [device.device_token]
        n.data = {}
        n.priority = 'high' # Optional, can be either 'normal' or 'high'
        n.content_available = true # Optional
        # Optional notification payload. See the reference below for more keys you can use!
        n.notification = {
          body: message, title: title, icon: 'ic_notification'
        }
        n.save
      end
    end
  end
end
