class AddIndexToTable < ActiveRecord::Migration[6.0]
  def change
    add_index :mobile_devices, [:device_type, :device_token], unique: true
  end
end
