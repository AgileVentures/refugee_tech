require 'rails_helper'

describe Api::V0::PingController do
  let(:user) {FactoryGirl.build(:user)}

  describe 'GET /v0/ping' do

    before { user.save }

    it 'should return Pong' do

      get '/api/v0/ping', params: nil, headers: {'X-User-Email': user.email, 'X-User-Token': user.authentication_token }
      expect(response.status).to eq 200
      expect(response_json['message']).to eq 'Pong'
    end

  end
end