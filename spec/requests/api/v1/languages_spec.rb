require 'rails_helper'

RSpec.describe "Languages management", :type => :request do

  let(:user) { FactoryGirl.create(:user) }

  let(:headers) { {HTTP_X_USER_EMAIL: user.email, HTTP_X_USER_TOKEN: user.authentication_token, HTTP_ACCEPT: 'application/json'} }
  let(:no_headers) { {HTTP_ACCEPT: 'application/json'} }

  ['English', 'French', 'Japanease'].each do |lang|
    let!(:"#{lang}") { FactoryGirl.create(:language, name: lang)  }
  end

  describe 'GET /api/v1/languages' do
    context 'non authenticated user' do
      it 'return warning msg' do
        get '/api/v1/languages', {}, no_headers
        expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
        expect(response.status).to eq 401
      end
    end
    context 'authenticated user' do
      it "returns list of all languages" do
        get '/api/v1/languages', {}, headers
        expect(response_json['languages'].size).to eq(3)
        expect(response.status).to eq 200
      end

    end
  end
end
