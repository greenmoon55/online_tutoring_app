class RequestsController < ApplicationController
  before_filter :require_sign , only:[:create,:destroy]
  def create
  end

  def destroy
  end

end
