class UsersController < ApplicationController
  include Godmin::Resources::ResourceController

  def unify(user)
    user.unify
  end
end
