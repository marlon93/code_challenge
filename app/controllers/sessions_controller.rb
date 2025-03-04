class SessionsController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    redirect_to root_path if logged_in?
  end

  def create
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: t('controllers.sessions.welcome')
    else
      flash.now[:alert] = t('alerts.invalid_credentials')
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: t('alerts.logout_success')
  end

  private

  def user
    @user ||= User.find_by(email: params[:email])
  end
end
