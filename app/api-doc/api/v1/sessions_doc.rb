module Api::V1::SessionsDoc
  extend Apipie::DSL::Concern

  api :POST, '/v1/users/sign_in', 'create new session'
  formats %w(json)
  example %q(
            Request:

              {"user":
                 {"email":"thomas@craftacademy.se",
                  "password":"password"
                 }
              }
            Response:
              {
                 "id":41,
                 "user_name":"Thomas Ochman",
                 "created_at":"2016-03-04T11:18:49.808Z",
                 "updated_at":"2016-03-04T11:24:06.082Z",
                 "email":"thomas@craftacademy.se",
                 "mentor":false,
                 "private":false,
                 "authentication_token":"ynvaUPDxMXfKrHcw164f"
              }


          )

  def create
  end
end