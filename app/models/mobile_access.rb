class MobileAccess < ApplicationRecord
  enum apns_version: { apns: 0, apnsp8: 1 }
  before_create :generate_server_token
  before_create :generate_client_token
  validates_presence_of :app_name, :email
  validates_uniqueness_of :app_name
  validates_with EmailAddress::ActiveRecordValidator, field: :email
  has_many :mobile_users

  private

  def generate_server_token
    self.server_token = SecureRandom.urlsafe_base64
    generate_server_token if MobileAccess.exists?(server_token: self.server_token)
  end

  def generate_client_token
    self.client_token = SecureRandom.urlsafe_base64
    generate_client_token if MobileAccess.exists?(client_token: self.client_token)
  end
end
