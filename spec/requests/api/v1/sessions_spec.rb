require 'rails_helper'

describe Api::V1::SessionsController do

  let(:user) { FactoryGirl.create(:user, latitude: 44, longitude: 13) }
  let(:user_2) { FactoryGirl.create(:user, latitude: nil, longitude: nil) }
  let(:headers) { {HTTP_ACCEPT: 'application/json'} }

  describe 'POST /api/v1/users/sign_in' do

    describe 'user log in' do
      it 'valid credentials returns user & token' do
        post '/api/v1/users/sign_in', {user: {email: "#{user.email}", password: "#{user.password}"}}, headers


        #{'X-User-Email' => user.email, 'X-User-Token' => user.authentication_token, 'HTTP_ACCEPT' => 'application/json' }

        expect(response_json).to eq('message' => 'success',
                                    'user' => {
                                        'id' => user.id,
                                        'user_name' => user.user_name,
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

      it 'should set a user address if is not already set' do
        post '/api/v1/users/sign_in', {user: {email: "#{user_2.email}", password: "#{user_2.password}"}}, {HTTP_ACCEPT: 'application/json',
                                                                                                          REMOTE_ADDR: '24.193.83.1'}
        
        expect(response_json).to eq('message' => 'success',
                            'user' => {
                                'id' => user_2.id,
                                'user_name' => user_2.user_name,
                                'email' => user_2.email,
                                'mentor' => false,
                                'lat' => nil,
                                'lng' => nil,
                                'city' => 'Rego Park',
                                'country' => 'United States',
                                'skills' => user_2.skills.reverse,
                                'token' => user_2.authentication_token
                            })
      end
      
      it 'invalid password returns error message' do
        post '/api/v1/users/sign_in', {user: {email: "#{user.email}", password: 'wrong_password'}}, headers
        expect(response_json).to eq('error' => 'Invalid email or password.')
        expect(response.status).to eq 401
      end

      it 'invalid email returns error message' do
        post '/api/v1/users/sign_in', {user: {email: 'wrong@email.com', password: "#{user.password}"}}, headers
        expect(response_json).to eq('error' => 'Invalid email or password.')
        expect(response.status).to eq 401
      end
    end

  end

  describe 'DELETE /api/v1/users/sign_out' do
    let(:sign_in_headers) { {HTTP_X_USER_EMAIL: user.email, HTTP_X_USER_TOKEN: user.authentication_token, HTTP_ACCEPT: 'application/json'} }

    describe 'user log out' do
      before do
        post '/api/v1/users/sign_in', {user: {email: "#{user.email}", password: "#{user.password}"}}, headers
        @old_token = user.authentication_token
        delete '/api/v1/users/sign_out', {}, sign_in_headers
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
      let(:wrong_sign_in_headers) { {HTTP_X_USER_EMAIL: user.email, HTTP_X_USER_TOKEN: 'xxxxxxxx', HTTP_ACCEPT: 'application/json'} }

      before do
        post '/api/v1/users/sign_in', {user: {email: "#{user.email}", password: "#{user.password}"}}, headers
        delete '/api/v1/users/sign_out', {}, wrong_sign_in_headers

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