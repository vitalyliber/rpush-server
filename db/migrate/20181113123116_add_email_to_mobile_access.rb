class AddEmailToMobileAccess < ActiveRecord::Migration[5.2]
  def change
    add_column :mobile_accesses, :email, :string
  end
end
