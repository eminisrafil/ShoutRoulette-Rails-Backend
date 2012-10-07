class UserSession < ActiveRecord::Base
  belongs_to :topic
  attr_accessible :ip_address, :observing, :last_checked, :token_id
end
