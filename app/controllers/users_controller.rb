class UsersController < ApplicationController
  def initialize_districts
    @districts = District.all.collect {|x| [x.name, x.id]}
  end
  def new
    @user = User.new
    initialize_districts
  end

  def new_teacher
    @user = User.new
    initialize_districts
  end

  def create
    @user = User.new(params[:user])
    if @user.save
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


end
