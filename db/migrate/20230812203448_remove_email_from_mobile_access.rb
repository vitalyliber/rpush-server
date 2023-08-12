class RemoveEmailFromMobileAccess < ActiveRecord::Migration[6.0]
  def change
    remove_column :mobile_accesses, :email, :string
  end
end
