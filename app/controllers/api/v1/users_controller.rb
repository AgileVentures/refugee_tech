class Api::V1::UsersController < ApiController

  include Api::V1::UsersDoc

  def index
    @users = User.all
  end


  def show
    @user = User.find(params[:id])
  end

  def unify
    @user = User.find(params[:id])
    @unified_users = @user.unify
  end

  def skills
    user = User.find(params[:id])
    if user.authentication_token == params[:user_token]
      user.skill_list = (params[:skills])
      user.save
      render json: {message: 'success'}
    else
      user.errors.add(:skills, 'could not perform operation')
      render json: {errors: user.errors}, status: 401
    end
  end
end

