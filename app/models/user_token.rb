class UserToken < ActiveRecord::Base
  attr_accessible :token_type, :token, :expires_after
  belongs_to :user
end
