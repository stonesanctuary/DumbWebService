class User < ActiveRecord::Base
  validates :devtoken, :presence => true, :uniqueness => true
  validates :udid, :presence => true, :uniqueness => true
end
