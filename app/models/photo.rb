class Photo < ActiveRecord::Base
  attr_accessible :name, :gallery_id, :image
  belongs_to :gallery
  mount_uploader :image, ImageUploader

  validates :name, :presence => true
end
