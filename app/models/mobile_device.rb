class MobileDevice < ApplicationRecord
  enum device_type: { android: 0, ios: 1 }
  belongs_to :mobile_user
  validates :device_type, :device_token, :mobile_user, presence: true
  validates_uniqueness_of :device_type, scope: [:device_token]
end
