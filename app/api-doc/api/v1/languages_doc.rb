module Api::V1::LanguagesDoc
  extend Apipie::DSL::Concern

  api :GET, '/v1/languages/', 'List of languages'
  formats %w(json)
  header :HTTP_ACCEPT, 'application/json', required: true
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  description 'Returns a list of possible Language'
  example %q(
  Response:
  {
   "languages":[
      {
         "id":1,
         "name":"English",
      },
      {
         "id":2,
         "name":"French",
      }
   ]
}

)

  def index
  end

  api :GET, '/v1/user/languages', 'List user\'s languages '
  description 'Returns list of user\s languages with details'
  formats %w(json)
  header :HTTP_ACCEPT, 'application/json', required: true
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  example %q(
  Response:
  {
    languages: [
      {
        "id"=>243,
        "language"=>"French",
        "level"=>"intermediate",
        "written"=>true,
        "spoken"=>true,
        "created_at"=>"2016-03-25T18:47:17.530Z"
        },
        { 
        "id"=>244,
        "language"=>"English",
        "level"=>"fluent",
        "written"=>true,
        "spoken"=>true,
        "created_at"=>"2016-03-25T18:47:17.535Z"
        }
    ]
})

  def my_languages
  end

  api :POST, '/v1/languages/', 'Create language for user'
  description 'Create user\'s language record'
  formats %w(json)
  header :HTTP_ACCEPT, 'application/json', required: true
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  example %q(
  Request:
  {
    "language" :
      {
        language_id: 15,
        spoken: true,
        written: true,
        level: "intermediate"
      }
  }

  Success Response:
  {
   "message": "Successfully saved language"
   }

   Error Response:
   { 
    "errors":
      { 
        "written" : ["can't be blank"],
        "spoken"=>["can't be blank"],
        "level"=>["can't be blank"]
      }
   }

)

  def create

  end

  api :PUT, '/v1/languages/:id', 'Edit language for user'
  description 'Edit user\'s language attributes'
  formats %w(json)
  header :HTTP_ACCEPT, 'application/json', required: true
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  example %q(
  Request:
  {
    "language" :
      {
        language_id: 15,
        spoken: true,
        written: true,
        level: "intermediate"
      }
  }
  Success Response:
  {
   "message": "Successfully updated language"
   }

   Error Response:
   { 
    "errors":
      { 
        "written" : ["can't be blank"],
        "spoken"=>["can't be blank"],
        "level"=>["can't be blank"]
      }
   }

)

  def update
  end

  api :DELETE, '/v1/languages/:id', 'Delete language for user'
  description 'Delete language for user'
  formats %w(json)
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  example %q(
  Response:
  {
   "message": "Successfully deleted language"
   }
)
  def destroy
  end
end
