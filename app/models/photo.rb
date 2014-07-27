class Photo < ActiveRecord::Base
  attr_accessible :name, :gallery_id
  belongs_to :gallery

  validates :name, :presence => true
end
