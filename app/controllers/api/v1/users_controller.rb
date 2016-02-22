class Api::V1::UsersController < ApiController

  swagger_controller :users, 'Users'

  swagger_api :index do
    summary 'Responds with a list of users'
    notes 'This lists all users in the system'
    response :unauthorized
  end

  def index
    @users = User.all
  end

  swagger_api :show do
    summary 'Responds with a user resource'
    param :path, :user, :string, :required, "User Id"
    response :ok, "Success", :User
    response :not_found
    response :bad_request
    notes 'Currently returns the same details as for a list but should return all details if the user is you'
  end

  def show
    @user = User.find(params[:user][:id])
  end
end