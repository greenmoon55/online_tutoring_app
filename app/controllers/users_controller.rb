class UsersController < ApplicationController
  before_filter :require_signin, only: [:edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update, :destroy]

  def initialize_districts
    @districts = District.all.collect {|x| [x.name, x.id]}
  end
  def new
    @user = User.new
    initialize_districts
  end

  def create
    role = (params[:user][:role] == "student")
    params[:user].delete :role
    @user = User.new(params[:user])
    @user.role = (role ? 1 : 0)
    if @user.save
      sign_in @user
      redirect_to @user
    else
      initialize_districts
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    initialize_districts
    @user = User.find(params[:id])
  end

  def update
    initialize_districts
    @user = User.find(params[:id])
    params[:user].delete :current_password
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render 'edit'
    end
  end
  
  def search
    
  end

  private
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        redirect_to root_path, notice: "非法操作"
      end
    end

end
