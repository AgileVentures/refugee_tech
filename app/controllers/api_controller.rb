class ApiController < ActionController::Base
  protect_from_forgery with: :null_session
  skip_before_filter :verify_authenticity_token

  before_action :destroy_session
  before_action :set_default_response_format

  acts_as_token_authentication_handler_for User

  clear_respond_to
  respond_to :json


  def destroy_session
    request.session_options[:skip] = true
  end

  protected

  def set_default_response_format
    request.format = :json
  end
end