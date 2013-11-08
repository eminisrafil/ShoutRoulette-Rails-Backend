# == Schema Information
#
# Table name: observers
#
#  id         :integer          not null, primary key
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Observer < ActiveRecord::Base
  belongs_to :room

  after_create :clean_up_old_observers
  def clean_up_old_observers
  	Observer.where("created_at <= :time" , {:time => 8.hours.ago}).destroy_all
  end
end
