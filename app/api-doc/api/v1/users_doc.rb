module Api::V1::UsersDoc
  extend Apipie::DSL::Concern

  api :GET, '/v1/users/', 'List of resources: User'
  formats %w(json)
  header :HTTP_ACCEPT, 'application/json', required: true
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  description 'Returns a list of registered users with URL\'s to #show for each instance'
  example %q(
  Response:
  {
   "users":[
      {
         "id":1,
         "user_name":"Thomas Ochman",
         "city": "Nuuk",
         "country": "Greenland",
         "created_at":"2016-02-22T17:46:07.045Z",
         "profile":"http://localhost:3000/api/v1/users/1"
      },
      {
         "id":2,
         "user_name":"Anders Andersson",
         "city": "Paris",
         "country": "France",
         "created_at":"2016-02-22T17:46:24.915Z",
         "profile":"http://localhost:3000/api/v1/users/2"
      }
   ]
}

)

  def index
  end

  api :GET, '/v1/users/:id', 'Show a :resource'
  description 'Returns an instance of user'
  formats %w(json)
  header :HTTP_ACCEPT, 'application/json', required: true
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  example %q(
  Response:
  {
   "user":{
      "id":1,
      "user_name":"Thomas Ochman",
      "introduction": "Introduction msg",
      "gender": "male",
      "lat": 82.1241969927258,
      "lng": -17.3820199231927,
      "city": "Nuuk",
      "country": "Greenland",
      "email": "email@email.com",
      "skills": [
        "rspec",
        "rails",
        "ruby"
      ],
      "created_at": "2016-03-23T16:39:32.371Z",
      "friends": [
        {
          "id": 12,
          "name": "Max",
          "url": "/users/max"
        }
      ],
      "pending_friendships": [
        {
          "id": 11,
          "name": "MB",
          "url": "/users/mb"
        }
      ]
   }
})

  def show
  end

  api :GET, '/v1/unify/:id', 'Show a list of matches for :resource'
  description 'Returns an instance of user with an array of matched users'
  formats %w(json)
  header :HTTP_ACCEPT, 'application/json', required: true
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  example %q(
  Response:
  {
   "user":{
      "id":1,
      "user_name":"Thomas Ochmane333",
      "skills":[
         "agile",
         "html",
         "management",
         "rspec",
         "test2",
         "test",
         "java"
      ],
      "created_at":"2016-02-22T17:46:07.045Z"
   },
   "matches":[
      {
         "user":{
            "id":2,
            "user_name":"Anders Andersson",
            "created_at":"2016-02-22T17:46:24.915Z",
            "skills":[
               "rspec",
               "html",
               "test",
               "management"
            ],
            "profile":"http://localhost:3000/api/v1/users/2"
         }
      },

      {
         "user":{
            "id":5,
            "user_name":"Kalle",
            "created_at":"2016-02-23T12:04:27.736Z",
            "skills":[
               "java",
               "html",
               "javascript"
            ],
            "profile":"http://localhost:3000/api/v1/users/5"
         }
      }
   ]
}

)

  def unify
  end

  api :POST, '/v1/skills/:id', 'Updates skill list for :resource'
  description 'Allows updating authorized resource to update its own skill list.'
  formats %w(json)
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  param :skills, String, :desc => 'Sending an empty string or omitting this params will delete the user\'s skill list'
  example %q(
  Request:
  {
    "skills" : "ruby, rails, rspec"
  }

  Response:
  {
    "message": "success"
  }
  
  )
  def skills
  end

  api :GET, '/v1/user/:id/friendship/:friend_id', 'Send friendship invitation'
  description 'Allow to send invitation from resource(:id) to resource(:friend_id)'
  formats %w(json)
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  example %q(
    Response:
  {
    "message": "successfully invidted user Miss Ted Stroman"
  }
  
  )
  def friendship
  end

  api :GET, '/v1/user/:id/friendship/:friend_id/confirm', 'Confirm friendship invitation'
  description 'Allow to confirm invitation from resource(:friend_id) by resource(:id)'
  formats %w(json)
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  example %q(
    Response:
  {
    "message": "successfully confirmed friendship with MB"
  }
  
  )
  def confirm_frienship
  end

  api :GET, '/v1/user/:id/friendship/:friend_id/block', 'block friendship invitation'
  description 'Allow to block invitation or remove friend  resource(:friend_id) by resource(:id)'
  formats %w(json)
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  example %q(
    Response:
  {
    "message": "successfully blocked friendship with MB"
  }
  
  )
  def block_frienship
  end
end
