class CreateMobileAccesses < ActiveRecord::Migration[5.2]
  def change
    create_table :mobile_accesses do |t|
      t.string :token
      t.string :app_name

      t.timestamps
    end
  end
end
