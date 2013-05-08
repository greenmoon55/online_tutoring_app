module SessionsHelper
  def sign_in(user)
    session[:user_id] = user.id
    self.current_user = user
  end

  # setter
  def current_user=(user)
    @current_user = user
  end

  # getter
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by_id(session[:user_id])
    end
    @current_user
  end

  def sign_out
    self.current_user = nil
    session.delete(:user_id)
  end
end
