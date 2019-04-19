class ChangeMobileUserExternalKeyToCaseInsensetive < ActiveRecord::Migration[5.2]
  def change
    enable_extension 'citext'
    change_column :mobile_users, :external_key, :citext
  end
end
