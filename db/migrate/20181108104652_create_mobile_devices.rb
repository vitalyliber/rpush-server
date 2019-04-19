class CreateMobileDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :mobile_devices do |t|
      t.integer :device_type, default: 0
      t.string :device_token
      t.references :mobile_user, foreign_key: true

      t.timestamps
    end

    add_index :mobile_devices, :device_type
  end
end
