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

  def receive
    @platform = Platform.find(params[:id])
    print('!!!!!!!!!!!!' + @platform.token)
    redirect_to :controller => 'platform_' + @platform.kind, :action => 'receive', :format => 'json', :token => @platform.token
  end
end
