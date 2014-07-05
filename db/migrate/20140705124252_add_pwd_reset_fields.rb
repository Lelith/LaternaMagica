class AddPwdResetFields < ActiveRecord::Migration
  def change
    add_column :users, :password_reset_token, :string
    add_column :users, :password_expires_after, :datetime
  end
end
  
