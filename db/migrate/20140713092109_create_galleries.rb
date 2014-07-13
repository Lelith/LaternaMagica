class CreateGalleries < ActiveRecord::Migration
  def up
    create_table :galleries do |t|
      t.belongs_to :user
      t.string :name
      t.timestamps
    end
  end

  def down
    drop_table :galleries
  end
end
