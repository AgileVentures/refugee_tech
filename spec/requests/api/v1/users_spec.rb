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

  describe 'Get /api/v1/users/:id' do
    let(:resource) { FactoryGirl.create(:user) }
    before do
      resource.update(skill_list: 'java-script, testing, ruby')
    end

    it 'should require authentication' do
      get "/api/v1/users/#{resource.id}", params: nil, headers:  no_headers
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

  describe 'GET /api/v1/unify' do
    let(:user_1) { FactoryGirl.create(:user, user_name: 'Thomas', mentor: true) }
    let(:user_2) { FactoryGirl.create(:user, user_name: 'Anders') }
    let(:user_3) { FactoryGirl.create(:user, user_name: 'Kalle') }
    let(:user_4) { FactoryGirl.create(:user, user_name: 'Sam', mentor: true) }

    before do
      user_1.update(skill_list: 'java-script, testing, ruby')
      user_2.update(skill_list: 'java-script, java, html')
      user_3.update(skill_list: 'java, html')
      user_4.update(skill_list: 'testing, ruby')
    end

    it 'should require authentication' do
      get "/api/v1/unify/#{user_1.id}", params: nil, headers: no_headers
      expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
      expect(response.status).to eq 401
    end

    it 'should return list of users' do
      get "/api/v1/unify/#{user_1.id}", params: nil, headers: headers
      expected_response = []
      user_1.unify.each do |user|
        hash = {id: user.id,
                user_name: user.user_name,
                created_at: user.created_at,
                skills: user.skill_list,
                profile: api_v1_user_url(user)}
        expected_response << {user: hash}
      end
      expect(response_json['matches']).to eq JSON.parse(expected_response.to_json)
    end

  end

  describe 'POST /api/v1/skills/:id' do
    let(:user_1) { FactoryGirl.create(:user) }
    let(:user_2) { FactoryGirl.create(:user) }

    let(:headers) { {'HTTP_X_USER_EMAIL': user_1.email, 'HTTP_X_USER_TOKEN': user_1.authentication_token, 'HTTP_ACCEPT': 'application/json'} }

    it 'should require authentication' do
      post "/api/v1/skills/#{user_1.id}", params: {skills: 'test, programing, cooking'}, headers: no_headers
      expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
      expect(response.status).to eq 401
    end

    it 'should update authorized users skills list' do
      post "/api/v1/skills/#{user_1.id}",  params: {skills: 'test, programing, cooking'}, headers: headers
      expect(response_json['message']).to eq('success')
      expect(response.status).to eq 200
    end

    it 'should delete skills if not passed in the params' do
      user_1.skill_list.add('test, programing, cooking', parse: true)
      post "/api/v1/skills/#{user_1.id}", params: {skills: 'test, cooking'}, headers: headers
      user_1.reload
      expect(user_1.skill_list).not_to include('programing')
    end

    it 'should reject updating other than authorized users skills list' do
      post "/api/v1/skills/#{user_2.id}", params: {skills: 'test, programing, cooking'}, headers: headers
      expect(response_json['errors']).to eq({'skills' => ['could not perform operation']})
      expect(response.status).to eq 401
    end

  end
  
  describe 'GET api/v1/user/:id/friendship/:friend_id' do
    let(:user_1) { FactoryGirl.create(:user) }
    let(:user_2) { FactoryGirl.create(:user) }  
    
    let(:headers) { {'HTTP_X_USER_EMAIL': user_1.email, 'HTTP_X_USER_TOKEN': user_1.authentication_token, 'HTTP_ACCEPT': 'application/json'} }
    
    it 'should require authentication' do
      get "/api/v1/user/#{user_2.id}/friendship/#{user_1.id}"
      expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
      expect(response.status).to eq 401
    end  
    
    it 'should make frienships between users' do
      get "/api/v1/user/#{user_1.id}/friendship/#{user_2.id}", {}, headers
      expect(response_json["message"]).to eq "successfully invited user #{user_2.user_name}"
      expect(user_2.invited_by? user_1)
      expect(user_2.invited? user_1)
      expect(user_2.pending_invited_by).to eq [user_1]
    end
  end
  
  describe 'GET api/v1/user/:id/friendship/:friend_id/confirm' do
    let(:user_1) { FactoryGirl.create(:user) }
    let(:user_2) { FactoryGirl.create(:user) } 
    let(:user_3) { FactoryGirl.create(:user) } 
    
    let(:headers) { {'HTTP_X_USER_EMAIL': user_1.email, 'HTTP_X_USER_TOKEN': user_1.authentication_token, 'HTTP_ACCEPT': 'application/json'} }
    
    it 'should require authentication' do
      user_1.invite user_2
      get "/api/v1/user/#{user_2.id}/friendship/#{user_1.id}/confirm"
      expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
      expect(response.status).to eq 401
    end
    
    it 'should confirm a friendship' do
      user_2.invite user_1
      get "/api/v1/user/#{user_1.id}/friendship/#{user_2.id}/confirm", params: nil, headers: headers
      expect(response_json["message"]).to eq "successfully confirmed friendship with #{user_2.user_name}"
      expect(user_2.friend_with? user_1)
      expect(user_1.friend_with? user_2)
    end
    
    it 'should have multiple friendships' do
      user_2.invite user_1
      user_3.invite user_1
      get "/api/v1/user/#{user_1.id}/friendship/#{user_2.id}/confirm", params: nil, headers: headers
      get "/api/v1/user/#{user_1.id}/friendship/#{user_3.id}/confirm", params: nil, headers: headers
      expect(user_1.friends).to eq [user_2, user_3]
    end
  end
  
  describe 'GET api/v1/user/:id/friendship/:friend_id/block' do
    let(:user_1) { FactoryGirl.create(:user) }
    let(:user_2) { FactoryGirl.create(:user) } 
    
    let(:headers) { {'HTTP_X_USER_EMAIL': user_2.email, 'HTTP_X_USER_TOKEN': user_2.authentication_token, 'HTTP_ACCEPT': 'application/json'} }
    
    it 'should require authentication' do
      user_1.invite user_2
      get "/api/v1/user/#{user_2.id}/friendship/#{user_1.id}/block"
      expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
      expect(response.status).to eq 401
    end  
    
    it 'should block a friendship request' do
      user_1.invite user_2
      get "/api/v1/user/#{user_2.id}/friendship/#{user_1.id}/block", params: nil, headers: headers
      expect(response_json["message"]).to eq "successfully blocked friendship with #{user_1.user_name}"
      expect(user_2.friend_with? user_1).to be_falsey
      expect(user_2.blocked? user_1)
    end
    
    it 'should block exsisting friendship' do
      user_1.invite user_2
      user_2.approve user_1
      get "/api/v1/user/#{user_2.id}/friendship/#{user_1.id}/block", params: nil, headers: headers
      expect(response_json["message"]).to eq "successfully blocked friendship with #{user_1.user_name}"
      expect(user_2.friend_with? user_1).to be_falsey
      expect(user_2.blocked? user_1)      
    end
  end
  
end

