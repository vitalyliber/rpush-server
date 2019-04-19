class AddClientTokenToMobileAccess < ActiveRecord::Migration[5.2]
  def change
    add_column :mobile_accesses, :client_token, :text
    rename_column :mobile_accesses, :token, :server_token
  end
end
