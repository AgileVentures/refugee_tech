module Api::V1::RegistrationsDoc
  extend Apipie::DSL::Concern

  api :POST, '/v1/users', 'create new user'
  formats %w(json)
  header :HTTP_ACCEPT, 'application/json', required: true

  param :user_name, String, desc: 'username', required: false
  param :email, String, desc: 'Email', required: false
  param :password, String, desc: 'password', required: true
  param :password_confirmatio, String, desc: 'password confirmatio', required: true

  example %q(
            Request:
            {
             "user":
               {
                 "user_name":"Thomas Ochman",
                  "email":"thomas@craftacademy.se",
                  "password":"password",
                  "password_confirmation":"password"
                }
            }

            Response:
            {
              "message":"success",
              "user":
                {
                  "id":42,
                  "user_name":"Thomas Ochman",
                  "token":"8TyjHFtPW3Y5CUN4dHG3"
                }
             }
          )

  def create
  end
end
