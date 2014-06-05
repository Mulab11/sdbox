class PlatformTestController < ApplicationController
  @@friends = {
    'zch' => ['ljb', 'flr', 'czt'],
    'ljn' => ['cxm', 'stz', 'hjx'],
    'cxm' => ['ljn', 'hjx', 'zch'],
    'wjy' => ['zch', 'ljn', 'ssq']
  }

  def bind
    tks = @@friends.map{|k,v| k}
    @token = tks[rand(tks.size)]
  end

  def receive
    cur = params[:token]
    friend = @@friends[cur]
    @res = []
    (0..10).each do |i|
      @res.push({
        'name' => friend[rand(friend.size)],
        'msg' => rand(1024).to_s
      })
    end
  end
end
