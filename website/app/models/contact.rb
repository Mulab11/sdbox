class Contact < ActiveRecord::Base
  belongs_to :user
  has_many :contact_items
  def join(item)
    tmp = item.contact
    item.contact_id = id
    item.save
    if tmp.contact_items.size == 0
      tmp.destroy
    end
  end
end
