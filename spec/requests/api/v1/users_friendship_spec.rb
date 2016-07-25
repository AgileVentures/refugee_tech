require 'rails_helper'
describe Api::V1::UsersController do
  let(:no_headers) { {'HTTP_ACCEPT': 'application/json'} }

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
      get "/api/v1/user/#{user_1.id}/friendship/#{user_2.id}", params: nil, headers: headers
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
    let(:user_1) { FactoryGirl.create(:user) }
    let(:user_2) { FactoryGirl.create(:user) }
    let(:user_3) { FactoryGirl.create(:user) }
    let(:headers) { {'HTTP_X_USER_EMAIL': user_2.email, 'HTTP_X_USER_TOKEN': user_2.authentication_token, 'HTTP_ACCEPT': 'application/json'} }

    it 'should require authentication' do
      user_1.invite user_2
      get "/api/v1/user/#{user_2.id}/friendship/#{user_1.id}/block", params: nil, headers: no_headers
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
    it 'should not allow users to block friendships other than owns' do
      user_1.invite user_3
      get "/api/v1/user/#{user_3.id}/friendship/#{user_1.id}/block", params: nil, headers: headers
      expect(response_json['errors']).to eq({'users' => ['could not perform operation']})
      expect(response.status).to eq 401
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