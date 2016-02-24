class Api::V1::UsersController < ApiController

  api :GET, '/v1/users/', 'List of resources: User'
  formats %w(json)
  description 'Returns a list of registered users with URL\'s to #show for each instance'
  example %q({"users":[
  {"id":1,
  "user_name":"Thomas Ochman",
  "created_at":"2016-02-22T17:46:07.045Z",
  "profile":"http://localhost:3000/api/v1/users/1"},
  {"id":2,
  "user_name":"Anders Andersson",
  "created_at":"2016-02-22T17:46:24.915Z",
  "profile":"http://localhost:3000/api/v1/users/2"}]
})

  def index
    @users = User.all
  end

  api :GET, '/v1/users/:id', 'Show a :resource'
  formats %w(json)
  description 'Returns an instance of user'
  example %q({"user":
  {"id":1,
    "user_name":"Thomas Ochman",
    "created_at":"2016-02-22T17:46:07.045Z"}
})

  def show
    @user = User.find(params[:id])
  end
end