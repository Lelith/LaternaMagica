class AddRightsManagementToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :is_private, :boolean
  end
end
