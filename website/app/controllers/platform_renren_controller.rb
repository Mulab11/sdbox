require 'net/http'
require 'net/https'

class PlatformRenrenController < ApplicationController
  @@RENREN_ENV = {
    'APP_ID' => '268863',
    'API_KEY' => 'c7ae949cd5194dccb5b4d11e0e9d0432',
    'SECRET_KEY' => '3836a8ef933d4cbc935b2e3e442e46ca',
    'REDIRECT_URI' => 'http://mulab.me:4321/access_token/renren/'
  }
  @@RENREN_ACCESS_TOKEN = 'https://graph.renren.com/oauth/token'
  @@RENREN_AUTH_URL = 'https://graph.renren.com/oauth/authorize'

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
      entry = Platform.where(:kind => 'renren', :uid => user['id'].to_s)
      if entry.length == 0
        puts "new platform"
        @platform = Platform.new(:token => token, :kind => 'renren', :user_id => session[:user], :name => user['name'], :uid => user['id'].to_s)
        @platform.save
      end
    end
    redirect_to '/'
  end
  
  def receive
  end
  
  def fresh
  end
  
  def send_message
  end
end
