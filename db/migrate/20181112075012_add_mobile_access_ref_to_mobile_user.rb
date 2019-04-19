class AddMobileAccessRefToMobileUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :mobile_users, :mobile_access, foreign_key: true
  end
end
