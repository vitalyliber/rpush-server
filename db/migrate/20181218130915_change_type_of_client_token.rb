class ChangeTypeOfClientToken < ActiveRecord::Migration[5.2]
  def change
    change_column :mobile_accesses, :client_token, :string
  end
end
