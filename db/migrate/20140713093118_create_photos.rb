class CreatePhotos < ActiveRecord::Migration
  def up
    create_table :photos do |t|
      t.belongs_to :gallery
      t.string :name
      t.timestamps
    end
  end

  def down
    drop_table photos
  end
end
