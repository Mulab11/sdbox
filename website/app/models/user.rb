class User < ActiveRecord::Base
  has_many :platforms
  has_many :contacts
  validates :name, uniqueness: true
  has_secure_password
  validates_presence_of :password, :on => :create
  
  def login()
    res = User.find_by_name(name)
    if not res
      errors.add(:name, 'is not registered')
      return User.new
    end
    res = res.try(:authenticate, password)
    if not res
      errors.add(:password, 'invalid')
      User.new
    else
      res
    end
  end
end
