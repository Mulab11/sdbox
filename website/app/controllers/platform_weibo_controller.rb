require 'net/http'
require 'net/https'

class PlatformWeiboController < ApplicationController
  @@WEIBO_ENV = {
    'APP_ID' => '1916610325',
    'APP_SECRET' => 'ff35f64cf73286a73a55216aca965983',
    'REDIRECT_URI' => "http://%s/access_token/weibo/"
  }
  @@WEIBO_ACCESS_TOKEN = "https://api.weibo.com/oauth2/access_token"
  @@WEIBO_AUTH_URL = "https://api.weibo.com/oauth2/authorize"
  
  def bind
    authorize_url = @@WEIBO_AUTH_URL.clone
    puts "weibo_authorize_url : %s" % @@WEIBO_AUTH_URL
    puts "authorize_url : %s" % authorize_url
    authorize_url << "?client_id=#{@@WEIBO_ENV["APP_ID"]}"
    authorize_url << "&response_type=code"
    authorize_url << "&redirect_uri=#{@@WEIBO_ENV["REDIRECT_URI"] % request.host_with_port}"  
    puts "authorize_url : %s" % authorize_url
    redirect_to(authorize_url)
  end
  
  def access_token
    p params[:code]
  	uri = URI.parse(@@WEIBO_ACCESS_TOKEN)
  	
  	http = Net::HTTP.new(uri.host, uri.port)
  	http.use_ssl = true if uri.scheme == 'https'
  	puts uri.host, uri.port, uri.path
  	
    uri.path << "?client_id=#{@@WEIBO_ENV["APP_ID"]}"
    uri.path << "&client_secret=#{@@WEIBO_ENV["APP_SECRET"]}"
    uri.path << "&grant_type=authorization_code"    
    uri.path << "&redirect_uri=#{@@WEIBO_ENV["REDIRECT_URI"]}"
    uri.path << "&code=#{params[:code]}"
    puts "access_token: %s" % uri.path
  	request = Net::HTTP::Post.new(uri.path)
	tokens = http.request(request).body
	puts "token : %s" % tokens
	@platform = Platform.new(:token => tokens, :kind => 'weibo', :user_id => session[:user], :name => "")
	@platform.save
	redirect_to("/")
  end
  
  def receive
  end
end

