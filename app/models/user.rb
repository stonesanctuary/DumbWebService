# == Schema Information
# Schema version: 20110726233038
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  udid       :string(255)
#  devtoken   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  validates :devtoken, :presence => true, :uniqueness => true
  validates :udid, :presence => true, :uniqueness => true
end
