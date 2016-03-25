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
  
  def friendship
    user = User.find(params[:id])
    friend = User.find(params[:friend_id])
    if user.authentication_token == params[:user_token]
      user.invite friend
      render json: {message: "successfully invidted user #{friend.user_name}"}
    else
      user.errors.add(:users, 'could not perform operation')
      render json: {errors: user.errors}, status: 401
    end
  end
  
  def confirm_frienship
    user = User.find(params[:id])
    friend = User.find(params[:friend_id])
    if user.authentication_token == params[:user_token] && (user.invited_by? friend)
      user.approve friend
      render json: {message: "successfully confirmed friendship with #{friend.user_name}"}
    else
      user.errors.add(:users, 'could not perform operation')
      render json: {errors: user.errors}, status: 401
    end    
  end
  
  def block_frienship
    user = User.find(params[:id])
    friend = User.find(params[:friend_id])
    if user.authentication_token == params[:user_token] && ( (user.invited_by? friend) || (user.friend_with friend) )
      user.block friend
      render json: {message: "successfully blocked friendship with #{friend.user_name}"}
    else
      user.errors.add(:users, 'could not perform operation')
      render json: {errors: user.errors}, status: 401
    end    
  end
end

