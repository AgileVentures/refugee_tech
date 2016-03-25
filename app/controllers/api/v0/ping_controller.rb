class Api::V0::PingController < ApiController

  api :GET, '/ping', 'Respond with \'Pong\''
  description 'Responds with a message containing the word \'Pong\''
  formats %w(json)
  example %q({ 'message': 'Pong' })

  def index
    render json: {message:'Pong'}
  end

end
