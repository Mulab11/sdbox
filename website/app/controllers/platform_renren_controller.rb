require 'net/http'
require 'net/https'

class PlatformRenrenController < ApplicationController
  @@RENREN_ENV = {
    'APP_ID' => '268863',
    'API_KEY' => 'c7ae949cd5194dccb5b4d11e0e9d0432',
    'SECRET_KEY' => '3836a8ef933d4cbc935b2e3e442e46ca',
    'REDIRECT_URI' => 'http://mulab.me:4321/access_token/renren/'
  }
  @@RENREN_ACCESS_TOKEN = 'https://api.weibo.com/oauth2/access_token'
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
