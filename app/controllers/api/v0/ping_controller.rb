class Api::V0::PingController < ApiController

  swagger_controller :ping, 'Ping'

  swagger_api :index do
    summary 'Responds with "Pong"Returns "Pong" to check the api is alive"'
  end

  def index
    respond_to do |format|
      format.json { render :json => JSON.parse('{"message":"Pong"}').to_json }
      format.text { render :text => 'Pong' }
    end

  end

end
