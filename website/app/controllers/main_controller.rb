require 'net/http'

class MainController < ApplicationController

  def index
    if not session[:user]
      respond_to do |format|
        format.html { redirect_to '/users/login_page' }
      end
      return
    end
    @user = User.find(session[:user])
  end

  def fresh
    @platform = Platform.find(params[:id])
    if @platform.user_id != session[:user]
      return
    end
    redirect_to :controller => 'platform_' + @platform.kind, :action => 'fresh', :format => 'json', :platform => @platform
  end

  def receive
    user = User.find(session[:user])
    user.platforms.each do |platform|
      begin
        eval("Platform" + "#{platform.kind}".humanize + "Controller").receive(platform)
        rescue
      end
    end
    @messages = Message.where(:user => user, :status => Message.recv_unread)
    @messages.each do |message|
      message.status = Message.recv_read
      message.save
    end
  end

  def send_message
    item = ContactItem.find(params[:id])
    if item.platform.user_id != session[:user]
      return
    end
    eval("Platform" + "#{item.platform.kind}".humanize + "Controller").send_message(item, params[:message])
    Message.new(:contact_item_id => item, :receive_time => Time.now, :status => Message.sent, :full_text => params[:message], :user_id => session[:user]).save
    @res = "success"
  end

  def send_page
    @item = ContactItem.find(params[:id])
    render '/main/send'
  end

  def test
    if not session[:user]
      respond_to do |format|
        format.html { redirect_to '/users/login_page' }
      end
      return
    end
    @user = User.find(session[:user])
  end

  def fonts
    redirect_to "/assets/#{params[:addr]}"
  end
end
