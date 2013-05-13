# encoding: utf-8
class UsersController < ApplicationController
  before_filter :require_signin, only: [:edit, :update, :destroy, :full_role]
  before_filter :correct_user,   only: [:edit, :update, :destroy, :full_role]

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
    logger.info current_role
    logger.info "in edit"
    if current_teacher?
      logger.info "here"
      render "edit_teacher"
      return
    end
    logger.info current_role
  end

  def update
    initialize_districts
    @user = User.find(params[:id])
    if params[:user][:current_password] 
      if @user.authenticate(params[:user][:current_password])
        @user.updating_password = true # RailsCasts #41
        params[:user].delete :current_password
      else
        flash.now[:notice] = "error"
        render 'edit' and return
      end
    else
      params[:user].delete :password
      params[:user].delete :password_confirmation
    end
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render 'edit'
    end
  end

  def full_role
    @user = User.find(params[:id])
    @user.role = 2
    @user.save!
    redirect_to @user
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
