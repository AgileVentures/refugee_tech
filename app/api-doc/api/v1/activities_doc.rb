module Api::V1::ActivitiesDoc
  extend Apipie::DSL::Concern

  api :GET, '/v1/activities', 'Get activity feed'
  formats %w(json)
  header :HTTP_ACCEPT, 'application/json', required: true
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true

  def index
  end
end