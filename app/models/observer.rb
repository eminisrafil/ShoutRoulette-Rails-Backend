class Observer < ActiveRecord::Base
  belongs_to :room
  # attr_accessible :title, :body
end
