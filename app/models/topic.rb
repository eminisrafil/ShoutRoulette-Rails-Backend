class Topic < ActiveRecord::Base
  has_many :tags
  has_many :rooms
  has_many :user_sessions
  attr_accessible :title, :position_1, :position_2
end
