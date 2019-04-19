class MobileUser < ApplicationRecord
  enum environment: { development: 0, production: 1 }
  validates :external_key, :environment, :mobile_access, presence: true
  validates_uniqueness_of :external_key, scope: [:environment, :mobile_access]
  has_many :mobile_devices
  belongs_to :mobile_access

  def send_pushes(title: '', message: '', device_type: 'all')
    self.mobile_devices.each do |device|
      if device.ios? && ['all', 'ios'].include?(device_type)
        n = Rpush::Apns::Notification.new
        n.app = Rpush::Apns::App.find_by(
            name: mobile_access.app_name,
            environment: environment,
        )
        n.device_token = device.device_token
        n.alert = {
            "title": title,
            "body": message
        }
        n.sound = 'default'
        n.data = {}
        n.save!
      end
      if device.android? && ['all', 'android'].include?(device_type)
        n = Rpush::Gcm::Notification.new
        n.app = Rpush::Gcm::App.find_by_name(mobile_access.app_name)
        n.registration_ids = [device.device_token]
        n.data = {}
        n.priority = 'high'        # Optional, can be either 'normal' or 'high'
        n.content_available = true # Optional
        # Optional notification payload. See the reference below for more keys you can use!
        n.notification = {
            body: message,
            title: title,
            icon: 'ic_notification'
        }
        n.save
      end
    end
  end
end
