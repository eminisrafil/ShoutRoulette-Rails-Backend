class Invite < ActiveRecord::Base
  attr_accessible :browser, :ip, :platform, :region, :version
end
