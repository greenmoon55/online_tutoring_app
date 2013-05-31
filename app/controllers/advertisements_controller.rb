# -*- encoding : utf-8 -*-
class AdvertisementsController < ApplicationController
  before_filter :require_signin, only: [:edit,:update,:create,:new,:destroy]
  before_filter :correct_user, only: [:edit,:update,:destroy]

  def index
    @teacher_advertisements = Advertisement.find_all_by_role(0)
    @student_advertisements = Advertisement.find_all_by_role(1)
  end

  def show
    @advertisement = Advertisement.find(params[:id])
  end

  def new
    @advertisement = Advertisement.new
  end

  def edit
    @advertisement = Advertisement.find(params[:id])
  end

  def create
    if current_student?
      role = 1
    else 
      role = 0
    end
    @advertisement = Advertisement.new(content: params[:advertisement][:content], user_id: current_user[:id], role: role)
    if @advertisement.save
      render 'show'
    else
      flash[:error] = "内容不能为空"
      redirect_to new_advertisement_path
    end
  end

  def update
    @advertisement = Advertisement.find(params[:id])
    if @advertisement.blank?
      flash.now[:error] = "内容不能为空"
      render 'edit'
    else   
      @advertisement.update_attributes(params[:advertisement])
      render 'show'
    end
  end

  def destroy
    @advertisement = Advertisement.find(params[:advertisement_id])
    @advertisement.destroy
    redirect_to advertisements_path
  end

  def correct_user
    @user = Advertisement.find(params[:id]).user
    if @user.nil?
      @user = Advertisement.find(params[:advertisement_id]).user
    end
    unless current_user?(@user)
      redirect_to root_path, notice: "非法操作"
    end
  end
end
