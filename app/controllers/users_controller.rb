class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :update, :destroy, :following, :followers]
  before_action :current_user_logged, only: [:edit, :update, :destroy]


  


  # GET /users
  # GET /users.json
  def index
    #@users = User.all
    if params[:search]
      @users = User.search(params[:search]).paginate(page: params[:page], per_page: 4)
    else
      @users = User.paginate(page: params[:page], per_page: 4)
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    @tweets = @user.tweets.paginate(page: params[:page])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def following
    @page_user = User.find(params[:id])
    @users = @page_user.following.paginate(page: params[:page])
    @page_title = 'Users that ' + @page_user.name + ' follows'
    render 'users_follow_page'
  end

  def followers
    @page_user = User.find(params[:id])
    @users = @page_user.followers.paginate(page: params[:page])
    @page_title = 'Users following ' + @page_user.name
    render 'users_follow_page'
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to @user, notice: 'User was successfully created. Welcome to Social Network' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    respond_to do |format|
      if @user.authenticate(@user.password)
        format.html { redirect_to @user, notice: 'User was successfully loged in.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :login }
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
    User.find(params[:id]).destroy
    log_out
    respond_to do |format|
      format.html { redirect_to signup_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :email_confirmation, :password, :password_confirmation, :description, :sex)
    end

    

    def current_user_logged
      @current_user_compare = User.find(params[:id])
      redirect_to(root_url) unless @current_user_compare == current_user
      #redirect_to(root_url) unless params[:id] == current_user.id
      #@user = User.find(params[:id])
      #redirect_to(root_url) unless @user == current_user
    end 

end
