class RemoveApnsVersionFromMobileAccess < ActiveRecord::Migration[6.0]
  def change
    remove_column :mobile_accesses, :apns_version, :integer, default: 0
  end
end
