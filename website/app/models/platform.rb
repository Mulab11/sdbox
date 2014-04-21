class Platform < ActiveRecord::Base
  belongs_to :user
  has_many :contact_item
  #attr_accessible :type, :token, :name, :user_id
end
