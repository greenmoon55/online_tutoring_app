# -*- encoding : utf-8 -*-
class StaticPagesController < ApplicationController
  def home
    @annoncements = Annoncement.order("created_at DESC").limit(3)
    @advertisements = Advertisement.order("created_at DESC").limit(2)
    @top_teachers = User.find_by_sql("SELECT * FROM users JOIN comments ON users.id = comments.teacher_id group by users.id order by count(*) DESC")
  end

  def about
  end
end
