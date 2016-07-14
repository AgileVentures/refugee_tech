require 'rails_helper'

describe Api::V1::SessionsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:headers) { {'HTTP_ACCEPT': 'application/json'} }

  describe 'POST /api/v1/users/sign_in' do

    describe 'user log in' do
      it 'valid credentials returns user & token' do
        post '/api/v1/users/sign_in', params: {user: {email: "#{user.email}", password: "#{user.password}"}}, headers: headers


        #{'X-User-Email' => user.email, 'X-User-Token' => user.authentication_token, 'HTTP_ACCEPT' => 'application/json' }

        expect(response_json).to eq('message' => 'success',
                                    'user' => {
                                        'id' => user.id,
                                        'user_name' => user.user_name,
                                        'introduction' => user.introduction,
                                        'email' => user.email,
                                        'mentor' => false,
                                        'lat' => user.latitude,
                                        'lng' => user.longitude,
                                        'city' => user.city,
                                        'country' => user.country,
                                        'skills' => user.skills.reverse,
                                        'token' => user.authentication_token
                                    })
        expect(user.authentication_token).to_not be nil
      end

      it 'invalid password returns error message' do
        post '/api/v1/users/sign_in', params: {user: {email: "#{user.email}", password: 'wrong_password'}}, headers: headers
        expect(response_json).to eq('error' => 'Invalid Email or password.')
        expect(response.status).to eq 401
      end

      it 'invalid email returns error message' do
        post '/api/v1/users/sign_in', params: {user: {email: 'wrong@email.com', password: "#{user.password}"}}, headers: headers
        expect(response_json).to eq('error' => 'Invalid Email or password.')
        expect(response.status).to eq 401
      end
    end

  end

  describe 'DELETE /api/v1/users/sign_out' do
    let(:sign_in_headers) { {'HTTP_X_USER_EMAIL': user.email, 'HTTP_X_USER_TOKEN': user.authentication_token, 'HTTP_ACCEPT': 'application/json'} }

    describe 'user log out' do
      before do
        post '/api/v1/users/sign_in', params: {user: {email: "#{user.email}", password: "#{user.password}"}}, headers: headers
        @old_token = user.authentication_token
        delete '/api/v1/users/sign_out', params: nil, headers: sign_in_headers
      end

      it 'should return success message' do
        expect(response_json['message']).to eq 'Session deleted'
      end

      it 'should return status 200 (we can\'t use 204 and return a message)' do
        expect(response.status).to eq 200
      end

      it 'should reset user authentication token' do
        user.reload
        expect(user.authentication_token).to_not eq @old_token
      end
    end

    describe 'with wrong headers' do
      let(:wrong_sign_in_headers) { {'HTTP_X_USER_EMAIL': user.email, 'HTTP_X_USER_TOKEN': 'xxxxxxxx', 'HTTP_ACCEPT': 'application/json'} }

      before do
        post '/api/v1/users/sign_in', params: {user: {email: "#{user.email}", password: "#{user.password}"}}, headers: headers
        delete '/api/v1/users/sign_out', params: nil, headers: wrong_sign_in_headers

      end

      it 'raises error response' do
        expect(response_json['error']).to eq 'Invalid token'
      end

      it 'raises authentication error' do
        expect(response.status).to eq 401
      end

    end
  end
end