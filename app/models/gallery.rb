class Gallery < ActiveRecord::Base
  attr_accessible :name
  has_many :photos
  belongs_to :user

  validates :name, :presence => true
end
