class PlatformTestController < ApplicationController
  @@friends = {
    'zch' => ['ljb', 'flr', 'czt', 'cxm', 'wjy'],
    'ljn' => ['cxm', 'stz', 'hjx', 'wjy'],
    'cxm' => ['ljn', 'hjx', 'zch'],
    'wjy' => ['zch', 'ljn', 'ssq']
  }
  @@sent = 0
  @@received = 1
  cattr_reader :sent, :received

  def bind
    tks = @@friends.map{|k,v| k}
    @platform = Platform.new(:token => tks[rand(tks.size)], :kind => 'test', :user_id => session[:user])
    #redirect_to '/'
  end

  def fresh
    platform = Platform.find(params[:platform])
    friend = @@friends[platform.token]
    items = friend.map{ |name| ContactItem.new(:name => name, :address => name)}
    platform.add_items(items)
    redirect_to '/'
  end

  def self.receive(platform)
    target = platform.token
    res = TestMessage.where(:target => target, :status => @@sent)
    items = {}
    platform.contact_items.each do |item|
      items[item.address] = item
    end
    #print("######\n")
    #print(items)
    res.each do |i|
      #print("!!!!!!!!!!\n")
      i.status = @@received
      i.save
      #printf("source = ");
      #print(i.source)
      #printf("\n")
      item = items[i.source]
      #printf("******************\n");
      #print("create = " + i.attributes_before_type_cast["created_at"] + "\n")
      Message.new(:contact_item_id => item.id, :receive_time => Time.now, :status => Message.recv_unread, :full_text => i.full_text, :user_id => platform.user.id).save
    end
  end

  def self.send_message(item, message)
    TestMessage.new(:source => item.platform.token, :target => item.address, :full_text => message, :status => @@sent).save
  end
end
