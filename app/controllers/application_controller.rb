# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
#  before_filter :update_online_status
  protect_from_forgery
  include SessionsHelper

  def update_online_status
    return unless signed_in?
    key = Time.now.strftime("%M").to_i
    $redis.sadd(key, current_user.id)
  end
end
