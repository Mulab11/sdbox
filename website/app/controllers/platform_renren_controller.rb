require 'net/http'
require 'net/https'

class PlatformRenrenController < ApplicationController
  @@RENREN_ENV = {
    'APP_ID' => '268863',
    'API_KEY' => 'c7ae949cd5194dccb5b4d11e0e9d0432',
    'SECRET_KEY' => '3836a8ef933d4cbc935b2e3e442e46ca',
    'REDIRECT_URI' => 'http://mulab.me:1234/access_token/renren/'
  }
  @@RENREN_ACCESS_TOKEN = 'https://graph.renren.com/oauth/token'
  @@RENREN_AUTH_URL = 'https://graph.renren.com/oauth/authorize'
  @@RENREN_FRIEND_LIST = 'https://api.renren.com/v2/user/friend/list'

  def bind
    authorize_url = @@RENREN_AUTH_URL.clone
    authorize_url << "?client_id=#{@@RENREN_ENV["APP_ID"]}"
    authorize_url << "&redirect_uri=#{@@RENREN_ENV["REDIRECT_URI"]}"  
    authorize_url << "&response_type=code"
    redirect_to(authorize_url)
  end
  
  def access_token
    if params[:error] != 'access_denied'
      uri = URI(@@RENREN_ACCESS_TOKEN)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      request = Net::HTTP::post_form(uri,
                                   'grant_type' => 'authorization_code',
                                   'token_type' => 'bearer',
                                   'grant_type' => 'authorization_code',
                                   'client_id' => @@RENREN_ENV["APP_ID"],
                                   'redirect_uri' => @@RENREN_ENV["REDIRECT_URI"],
                                   'client_secret' => @@RENREN_ENV["SECRET_KEY"],
                                   'code' => params[:code])
      token = request.body
      puts "token : %s" % token
      token_json = JSON.parse(token)

      user = token_json['user']
      puts user['name']
      puts user['id'].to_s
      entry = Platform.where(:kind => 'renren', :uid => user['id'].to_s)
      if entry.length == 0
        puts "new platform"
        @platform = Platform.new(:token => token, :kind => 'renren', :user_id => session[:user], :name => user['name'], :uid => user['id'].to_s)
        @platform.save
      end
    end
    redirect_to '/'
  end
  
  def fresh
    platform = Platform.find(params[:platform])
    token_json = JSON.parse(platform.token)
    
    puts platform.uid
    params = {:access_token => token_json['access_token'], :userId => platform.uid.to_i, :pageSize => 100, :pageNumber => 1}
    uri = URI(@@RENREN_FRIEND_LIST)
    uri.query = URI.encode_www_form(params)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    request = Net::HTTP::get_response(uri)
    friend_list = request.body
    friend_list_json = JSON.parse(friend_list)
    p friend_list_json

    friends = friend_list_json['response']
    @friends = []
    friends.each do |friend|
      entry = ContactItem.where(:name => friend['name'], :address => friend['id'])
      if entry.length == 0
        @friends.push({:name => friend['name'], :address => friend['id']})
      end
    end

    items = @friends.map {|friend| ContactItem.new(friend)}
    platform.add_items(items)
    redirect_to '/'
  end
  
  def receive
  end
  
  def send_message
  end
end
