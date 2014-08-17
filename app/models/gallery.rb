class Gallery < ActiveRecord::Base
  attr_accessible :name, :user_id, :is_private
  has_many :photos
  belongs_to :user

  validates :name, :presence => true
end
