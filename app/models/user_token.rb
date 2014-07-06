class UserToken < ActiveRecord::Base
  attr_accessible :type, :token, :expires_after
  belongs_to :user
end
