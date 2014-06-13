class Message < ActiveRecord::Base
  #status: 
  # 0 received & unread
  # 1 received & read
  # 2 sent
  cattr_reader :recv_unread, :recv_read, :sent
  @@recv_unread = 0
  @@recv_read = 1
  @@sent = 2

  belongs_to :user
  belongs_to :contact_item
end
