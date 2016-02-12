class Api::V0::PingController < Api::V0::BaseController

  def index
    respond_to do |format|
      format.json { render :json => JSON.parse('{"message":"Pong"}').to_json }
      format.text { render :text => 'Pong' }
    end

  end

end
