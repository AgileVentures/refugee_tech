class ApplicationController < ActionController::Base
  include Godmin::ApplicationController
  include Godmin::Authentication

  def admin_user_class
    AdminUser
  end

  def authenticate_admin_user
    unless admin_user_signed_in? || controller_name == 'sessions'
      if devise_controller?
        authenticate_user!
      else
        redirect_to new_session_path, alert: 'Authentication needed'
      end
    end
  end

  def authenticate_user!(opts={})
    opts[:scope] = :user
    warden.authenticate!(opts) if !devise_controller? || opts.delete(:force)
  end

  #
  # def admin_user
  #   current_user if devise_controller?
  # end
  #
  # def admin_user_signed_in?
  #   user_signed_in? if devise_controller?
  # end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
