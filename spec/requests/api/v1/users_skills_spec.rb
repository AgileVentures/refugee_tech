require 'rails_helper'
describe Api::V1::UsersController do
  let(:no_headers) { {'HTTP_ACCEPT': 'application/json'} }

  describe 'POST /api/v1/skills/:id' do
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let(:headers) { {'HTTP_X_USER_EMAIL': user_1.email, 'HTTP_X_USER_TOKEN': user_1.authentication_token, 'HTTP_ACCEPT': 'application/json'} }

    it 'should require authentication' do
      post "/api/v1/skills/#{user_1.id}", params: {skills: 'test, programing, cooking'}, headers: no_headers
      expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
      expect(response.status).to eq 401
    end

    it 'should update authorized users skills list' do
      post "/api/v1/skills/#{user_1.id}", params: {skills: 'test, programing, cooking'}, headers: headers
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
end