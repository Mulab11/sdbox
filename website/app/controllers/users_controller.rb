class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  def get_all
    if not session[:user]
      return
    end
    @user = User.find(session[:user])
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @action = 'create'
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def login_page
    @user = User.new
    @action = 'login'
  end

  def login
    @user = User.new(user_params).login
    /if @user.login
      session[:user_id] = @user.id
      redirect_to root_url, :notice => "Logged in!"
    else
      flash.now.alert = "Invalid name or password"
      @user = User.new
      render :login_page
    end/

    respond_to do |format|
      if @user.id
        session[:user] = @user.id
        print('!!!!!!!!!!!!!!!!!session = ' + session[:user].to_s)
        format.html { redirect_to root_url, notice: 'Logged in!' }
        #format.json { render :show, status: :created, location: @user }
      else
        @action = 'login'
        format.html { render :login_page }
        #format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def hello
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :password)
    end

end
