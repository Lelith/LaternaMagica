class Gallery < ActiveRecord::Base
  attr_accessible :name, :user_id
  has_many :photos
  belongs_to :user

  validates :name, :presence => true
end
