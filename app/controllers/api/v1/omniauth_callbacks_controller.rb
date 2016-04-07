class Api::V1::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token
  before_action :set_default_response_format
  clear_respond_to
  respond_to :json

  def facebook
    resource_class = ActiveRecord::Base::User
    self.resource = resource_class.from_omniauth(request.env['omniauth.auth'])
    if resource.persisted?
      sign_in(resource_name, resource)
      @resource = resource
      @credentials = request.env['omniauth.auth']['credentials']
      render 'api/v1/users/success'
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      render json: {errors: 'could not perform login'}, status: 401
    end
  end

  def failure
    render json: {errors: 'authentication error'}, status: 401
  end

  protected
  def set_default_response_format
    request.format = :json
  end
end