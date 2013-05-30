class AnnoncementsController < ApplicationController
  before_filter :require_signin, only: [:new, :edit, :update, :create, :destroy]
  before_filter :require_admin, only: [:new, :edit, :update, :create, :destroy]
  # GET /annoncements
  # GET /annoncements.json
  def index
    @annoncements = Annoncement.all
=begin
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @annoncements }
    end
=end
  end

  # GET /annoncements/1
  # GET /annoncements/1.json
  def show
    @annoncement = Annoncement.find(params[:id])
=begin
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @annoncement }
    end
=end
  end

  # GET /annoncements/new
  # GET /annoncements/new.json
  def new
    @annoncement = Annoncement.new
=begin
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @annoncement }
    end
=end
  end

  # GET /annoncements/1/edit
  def edit
    @annoncement = Annoncement.find(params[:id])
  end

  # POST /annoncements
  # POST /annoncements.json
  def create
    @annoncement = Annoncement.new(params[:annoncement])
    if @annoncement.save
      flash.now[:success] = "公告创建成功"
      render 'show'
    else
      flash.now[:error] = "公告标题或者内容不能为空"
      render 'new'
    end
=begin
    respond_to do |format|
      if @annoncement.save
        format.html { redirect_to @annoncement, notice: 'Annoncement was successfully created.' }
        format.json { render json: @annoncement, status: :created, location: @annoncement }
      else
        format.html { render action: "new" }
        format.json { render json: @annoncement.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # PUT /annoncements/1
  # PUT /annoncements/1.json
  def update
    @annoncement = Annoncement.find(params[:id])
    if @annoncement.update_attributes(params[:annoncement])
      flash.now[:success] = "公告更新成功"
      render 'show'
    else
      flash.now[:error] = "公告标题或者内容不能为空"
      render 'edit'
    end
=begin
    respond_to do |format|
      if @annoncement.update_attributes(params[:annoncement])
        format.html { redirect_to @annoncement, notice: 'Annoncement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @annoncement.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # DELETE /annoncements/1
  # DELETE /annoncements/1.json
  def destroy
    @annoncement = Annoncement.find(params[:annoncement_id])
    @annoncement.destroy
    redirect_to annoncements_path
=begin
    respond_to do |format|
      format.html { redirect_to annoncements_url }
      format.json { head :no_content }
    end
=end
  end

end
