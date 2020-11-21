class AddApns8Support < ActiveRecord::Migration[5.2]
  def change
    add_column :mobile_accesses, :apns_version, :integer, default: 0
  end
end
