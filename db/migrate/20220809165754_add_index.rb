class AddIndex < ActiveRecord::Migration[6.0]
  def change
    add_index :mobile_users, [:external_key, :environment, :mobile_access_id], unique: true, name: "index_uniq_combination"
  end
end
