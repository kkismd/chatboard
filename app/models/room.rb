class Room < ActiveRecord::Base
  attr_accessible :deleted_at, :serial, :title
end
