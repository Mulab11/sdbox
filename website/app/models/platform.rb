class Platform < ActiveRecord::Base
  belongs_to :user
  has_many :contact_items
  #attr_accessible :type, :token, :name, :user_id

  @@supp = ['test', 'renren', 'weixin', 'weibo']
  def self.supported
    @@supp
  end

  def add_items(items)
    used = {}
    contact_items.each do |item|
      used[item.address] = true
    end
    items.each do |item|
      unless used.include? item.address
        item.contact = Contact.new(:name => item.name, :user => user)
        item.platform = self
        #item.contact.save
        item.save
      end
    end
  end
end
