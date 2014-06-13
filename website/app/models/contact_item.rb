class ContactItem < ActiveRecord::Base
  belongs_to :platform
  belongs_to :contact
  has_many :messages
end
