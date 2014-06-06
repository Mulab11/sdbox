class PlatformTestController < ApplicationController
  @@friends = {
    'zch' => ['ljb', 'flr', 'czt'],
    'ljn' => ['cxm', 'stz', 'hjx'],
    'cxm' => ['ljn', 'hjx', 'zch'],
    'wjy' => ['zch', 'ljn', 'ssq']
  }

  def bind
    tks = @@friends.map{|k,v| k}
    @platform = Platform.new(:token => tks[rand(tks.size)], :kind => 'test', :user_id => session[:user])
  end

  def fresh
    platform = Platform.find(params[:platform])
    friend = @@friends[platform.token]
    items = friend.map{ |name| ContactItem.new(:name => name, :address => name)}
    platform.add_items(items)
    redirect_to '/users/get_all.json'
  end

  def receive
    cur = Platform.find(params[:platform]).token
    friend = @@friends[cur]
    @res = []
    (0..10).each do |i|
      @res.push({
        'name' => friend[rand(friend.size)],
        'msg' => rand(1024).to_s
      })
    end
  end

  def send_message
    @item = ContactItem.find(params[:contact_item])
    @message = params[:message]
    render '/platform_test/send'
  end
end
