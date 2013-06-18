# -*- encoding : utf-8 -*-
class StaticPagesController < ApplicationController
  def home
    @annoncements = Annoncement.order("created_at DESC").limit(3)
  end

  def about
  end
end
