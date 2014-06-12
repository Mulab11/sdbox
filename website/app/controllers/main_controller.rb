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
    platform = Platform.find(params[:id])
    if platform.user_id != session[:user]
      return
    end
    redirect_to :controller => 'platform_' + platform.kind, :action => 'receive', :format => 'json', :platform => platform
  end

  def send_message
    item = ContactItem.find(params[:id])
    if item.platform.user_id != session[:user]
      return
    end
    redirect_to :controller => 'platform_' + item.platform.kind, :action => 'send_message', :contact_item => item, :message => params[:message]
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
