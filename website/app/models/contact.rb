class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :contact_items
end
