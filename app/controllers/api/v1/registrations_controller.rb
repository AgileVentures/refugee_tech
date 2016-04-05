class Api::V1::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create]
  before_action :set_default_response_format

  skip_before_action :verify_authenticity_token
  include Api::V1::RegistrationsDoc
  clear_respond_to
  respond_to :json


  def create
    self.resource = build_resource(sign_up_params.merge params['user'])
    resource.ip_address = request.remote_ip if resource.latitude.blank? || resource.longitude.blank?
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        @resource = resource
        render 'api/v1/users/success'
      else
        expire_data_after_sign_in!
        respond_with resource #, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:user_name, :email, :password, :provider, :uid, :latitude, :longitude ) }
  end

  def set_default_response_format
    request.format = :json
  end

end