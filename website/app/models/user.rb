class User < ActiveRecord::Base
  has_many :platform
  has_many :contact
  #attr_accessible :name, :pwd
end
