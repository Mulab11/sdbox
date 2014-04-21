class ContactItem < ActiveRecord::Base
  belongs_to :platform
  belongs_to :contact
end
