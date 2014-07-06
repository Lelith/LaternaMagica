class AddUserActivation < ActiveRecord::Migration
  def change
    add_column :users, :is_active, :boolean
    add_column :users, :activated_at, :datetime
  end
end
