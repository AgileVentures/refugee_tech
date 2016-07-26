require 'rails_helper'
describe Api::V1::UsersController do
  let(:user_1) { FactoryGirl.create(:user) }
  let(:user_2) { FactoryGirl.create(:user) }
  let(:user_3) { FactoryGirl.create(:user) }
  let(:no_headers) { {'HTTP_ACCEPT': 'application/json'} }
  let(:headers) { {'HTTP_X_USER_EMAIL': user_1.email, 'HTTP_X_USER_TOKEN': user_1.authentication_token, 'HTTP_ACCEPT': 'application/json'} }

 describe 'GET api/v1/user/:id/friendship/:friend_id' do

    it 'should require authentication' do
      get "/api/v1/user/#{user_2.id}/friendship/#{user_1.id}"
      expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
      expect(response.status).to eq 401
    end

    it 'should make friendships between users' do
      get "/api/v1/user/#{user_1.id}/friendship/#{user_2.id}", params: nil, headers: headers
      expect(response_json["message"]).to eq "successfully invited user #{user_2.user_name}"
      expect(user_2.invited_by? user_1)
      expect(user_2.invited? user_1)
      expect(user_2.pending_invited_by).to eq [user_1]
    end
    
    it 'should not allow users to make friendships for other users' do
      get "/api/v1/user/#{user_2.id}/friendship/#{user_3.id}", params: nil, headers: headers
      expect(response_json['errors']).to eq({'users' => ['could not perform operation']})
      expect(response.status).to eq 401
    end
    
  end

  describe 'GET api/v1/user/:id/friendship/:friend_id/confirm' do
    
    it 'should require authentication' do
      get "/api/v1/user/#{user_2.id}/friendship/#{user_1.id}/confirm", params: nil, headers: no_headers
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
    
    it 'should not allow users to block friendships other than owns' do
      user_2.invite user_3
      get "/api/v1/user/#{user_3.id}/friendship/#{user_2.id}/confirm", params: nil, headers: headers
      expect(response_json['errors']).to eq({'users' => ['could not perform operation']})
      expect(response.status).to eq 401
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
    
    it 'should require authentication' do
      get "/api/v1/user/#{user_2.id}/friendship/#{user_1.id}/block", params: nil, headers: no_headers
      expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
      expect(response.status).to eq 401
    end

    it 'should block a friendship request' do
      user_2.invite user_1
      get "/api/v1/user/#{user_1.id}/friendship/#{user_2.id}/block", params: nil, headers: headers
      expect(response_json["message"]).to eq "successfully blocked friendship with #{user_2.user_name}"
      expect(user_1.friend_with? user_2).to be_falsey
      expect(user_1.blocked? user_2)
    end
    it 'should not allow users to block friendships other than owns' do
      user_2.invite user_3
      get "/api/v1/user/#{user_3.id}/friendship/#{user_2.id}/block", params: nil, headers: headers
      expect(response_json['errors']).to eq({'users' => ['could not perform operation']})
      expect(response.status).to eq 401
    end

    it 'should block exsisting friendship' do
      user_2.invite user_1
      user_1.approve user_2
      get "/api/v1/user/#{user_1.id}/friendship/#{user_2.id}/block", params: nil, headers: headers
      expect(response_json["message"]).to eq "successfully blocked friendship with #{user_2.user_name}"
      expect(user_1.friend_with? user_2).to be_falsey
      expect(user_1.blocked? user_2)
    end
  end
  
  describe 'GET api/v1/user/:id/pending_friendships/index' do
    
    let(:user_4) { FactoryGirl.create(:user) } 
    
    it 'should require authentication' do
      get "/api/v1/user/#{user_2.id}/pending_friendships/index", params: nil, headers: no_headers
      expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
      expect(response.status).to eq 401
    end
    
    it 'should response with list of pending friendships' do
      user_2.invite user_1
      user_3.invite user_1
      user_4.invite user_1
      user_1.approve user_4
      expected_response = [{id: user_2.id,
                                     user_name: user_2.user_name,
                                     city: user_2.city,
                                     country: user_2.country,
                                     created_at: user_2.created_at,
                                     profile: api_v1_user_url(user_2)},
                            {id: user_3.id,
                                     user_name: user_3.user_name,
                                     city: user_3.city,
                                     country: user_3.country,
                                     created_at: user_3.created_at,
                                     profile: api_v1_user_url(user_3)}]
      get "/api/v1/user/#{user_1.id}/pending_friendships/index", params: nil, headers: headers
      expect(response_json['users']).to eq JSON.parse(expected_response.to_json)
    end
  end
  
  describe 'GET api/v1/user/:id/friendships/index' do
    
    it 'should require authentication' do
      get "/api/v1/user/#{user_2.id}/friendships/index", params: nil, headers: no_headers
      expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
      expect(response.status).to eq 401
    end
    
    it 'should return list of friendships' do
      user_2.invite user_1
      user_1.approve user_2
      user_1.invite user_3
      user_3.approve user_1
      expected_response = [{id: user_2.id,
                                     user_name: user_2.user_name,
                                     city: user_2.city,
                                     country: user_2.country,
                                     created_at: user_2.created_at,
                                     profile: api_v1_user_url(user_2)},
                            {id: user_3.id,
                                     user_name: user_3.user_name,
                                     city: user_3.city,
                                     country: user_3.country,
                                     created_at: user_3.created_at,
                                     profile: api_v1_user_url(user_3)}]
      get "/api/v1/user/#{user_1.id}/friendships/index", params: nil, headers: headers
      expect(response_json['users']).to eq JSON.parse(expected_response.to_json)
    end
  end
end