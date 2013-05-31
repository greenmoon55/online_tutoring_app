class AnnoncementsController < ApplicationController
  before_filter :require_signin, only: [:new, :edit, :update, :create, :destroy]
  before_filter :require_admin, only: [:new, :edit, :update, :create, :destroy]
  def index
    @annoncements = Annoncement.all
  end

  def show
    @annoncement = Annoncement.find(params[:id])
  end

  def new
    @annoncement = Annoncement.new
  end

  def edit
    @annoncement = Annoncement.find(params[:id])
  end

  def create
    @annoncement = Annoncement.new(params[:annoncement])
    if @annoncement.save
      flash.now[:success] = "公告创建成功"
      render 'show'
    else
      flash.now[:error] = "公告标题或者内容不能为空"
      render 'new'
    end
  end

  def update
    @annoncement = Annoncement.find(params[:id])
    if @annoncement.update_attributes(params[:annoncement])
      flash.now[:success] = "公告更新成功"
      render 'show'
    else
      flash.now[:error] = "公告标题或者内容不能为空"
      render 'edit'
    end
  end

  def destroy
    @annoncement = Annoncement.find(params[:id])
    @annoncement.destroy
    redirect_to annoncements_path
  end

end
