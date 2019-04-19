class CreateMobileUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :mobile_users do |t|
      t.string :external_key
      t.integer :environment, default: 0

      t.timestamps
    end

    add_index :mobile_users, :external_key
  end
end
