require 'rails_helper'
#its important for SimpleCov in order to merge the test results correctly
#that in one file of each test folder we specify a command_name
SimpleCov.command_name 'test:functionals'

describe Api::V1::UsersController do
  let(:user) { FactoryGirl.create(:user) }

  let(:headers) { {'HTTP_X_USER_EMAIL': user.email, 'HTTP_X_USER_TOKEN': user.authentication_token, 'HTTP_ACCEPT': 'application/json'} }
  let(:no_headers) { {'HTTP_ACCEPT': 'application/json'} }

  before { FactoryGirl.create_list(:user, 3) }

  describe 'GET /api/v1/users' do
    it 'should require authentication' do
      get '/api/v1/users', params: nil, headers: no_headers
      expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
      expect(response.status).to eq 401
    end

    it 'should return list of users' do
      get '/api/v1/users', params: nil, headers: headers
      collection = []
      User.all.each do |user|
        collection << {id: user.id,
                       user_name: user.user_name,
                       city: user.city,
                       country: user.country,
                       created_at: user.created_at,
                       profile: api_v1_user_url(user)}
      end
      expected_response = {users: collection}
      expect(response_json).to eq JSON.parse(expected_response.to_json)
    end

  end

  describe 'GET /api/v1/users/:id' do
    let(:resource) { FactoryGirl.create(:user) }
    before do
      resource.update(skill_list: 'java-script, testing, ruby')
    end

    it 'should require authentication' do
      get "/api/v1/users/#{resource.id}", params: nil, headers: no_headers
      expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
      expect(response.status).to eq 401
    end

    it 'should return a user resource' do
      get "/api/v1/users/#{resource.id}", params: nil, headers: headers
      expected_response = {user: {id: resource.id,
                                  user_name: resource.user_name,
                                  introduction: resource.introduction,
                                  gender: resource.gender,
                                  lat: resource.latitude,
                                  lng: resource.longitude,
                                  city: resource.city,
                                  country: resource.country,
                                  email: resource.email,
                                  skills: resource.skill_list.reverse,
                                  created_at: resource.created_at,
                                  friends: resource.friends,
                                  pending_friendships: resource.pending_invited_by}}
      expect(response_json).to eq JSON.parse(expected_response.to_json)
    end

  end

end

