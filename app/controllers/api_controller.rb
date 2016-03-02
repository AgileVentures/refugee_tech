class ApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery with: :null_session
  
  before_action :destroy_session
  before_action :default_response_format


  def destroy_session
    request.session_options[:skip] = true
  end

  protected

  def default_response_format
    request.format = :json
  end
end