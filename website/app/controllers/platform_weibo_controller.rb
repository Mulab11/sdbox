require 'net/http'
require 'net/https'
require 'json'

class PlatformWeiboController < ApplicationController
  @@WEIBO_ENV = {
    'APP_ID' => '1916610325',
    'APP_SECRET' => 'ff35f64cf73286a73a55216aca965983',
    'REDIRECT_URI' => 'http://mulab.me:1234/access_token/weibo/'
  }
  @@WEIBO_ACCESS_TOKEN = 'https://api.weibo.com/oauth2/access_token'
  @@WEIBO_AUTH_URL = 'https://api.weibo.com/oauth2/authorize'
  @@WEIBO_USERS_SHOW = 'https://api.weibo.com/2/users/show.json'
  @@WEIBO_FRIENDSHIPS_FRIENDS = 'https://api.weibo.com/2/friendships/friends.json'
  @@WEIBO_COMMENTS_TIMELINE = 'https://api.weibo.com/2/comments/by_me.json'

  
  def bind
    authorize_url = @@WEIBO_AUTH_URL.clone
    authorize_url << "?client_id=#{@@WEIBO_ENV["APP_ID"]}"
    authorize_url << "&response_type=code"
    authorize_url << "&redirect_uri=#{@@WEIBO_ENV["REDIRECT_URI"]}"  
    redirect_to authorize_url
  end
  
  def access_token
    uri = URI(@@WEIBO_ACCESS_TOKEN)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    request = Net::HTTP::post_form(uri,
                                   'client_id' => @@WEIBO_ENV["APP_ID"],
                                   'client_secret' => @@WEIBO_ENV["APP_SECRET"],
                                   'grant_type' => 'authorization_code',
                                   'redirect_uri' => @@WEIBO_ENV["REDIRECT_URI"],
                                   'code' => params[:code])
    token = request.body
    puts "token : %s" % token
    token_json = JSON.parse(token)
    p token_json

    params = {:access_token => token_json['access_token'], :uid => token_json['uid'] }
    uri = URI(@@WEIBO_USERS_SHOW)
    uri.query = URI.encode_www_form(params)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    request = Net::HTTP::get_response(uri)
    p params[:access_token]
    p params[:uid]
    user_show = request.body
    user_show_json = JSON.parse(user_show)
    
    entry = Platform.where(:kind => 'weibo', :uid => user_show_json['id'].to_s)
    if entry.length == 0
      puts "new platform"
      @platform = Platform.new(:token => token, :kind => 'weibo', :user_id => session[:user], :name => user_show_json['name'], :uid => user_show_json['id'].to_s)
      @platform.save
    end
    redirect_to "/"
  end
  
  def fresh
    platform = Platform.find(params[:platform])
    token_json = JSON.parse(platform.token)
    puts token_json['access_token']
    
    params = {:access_token => token_json['access_token'], :uid => token_json['uid'], :count => 50, :cursor => 0, :trim_status => 0}
    uri = URI(@@WEIBO_FRIENDSHIPS_FRIENDS)
    uri.query = URI.encode_www_form(params)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    request = Net::HTTP::get_response(uri)
    friendships_friends = request.body
    friendships_friends_json = JSON.parse(friendships_friends)
    
    friends = friendships_friends_json['users']
    @friends = []
    friends.each do |friend|
      entry = ContactItem.where(:name => friend['name'], :address => friend['id'])
      if entry.length == 0
        @friends.push({:name => friend['name'], :address => friend['id']})
      end
    end
    items = @friends.map {|friend| ContactItem.new(friend)}
    platform.add_items(items)
    redirect_to '/users/get_all.json'
  end
  
  def receive
  end
  
  def send_message
  end
end

