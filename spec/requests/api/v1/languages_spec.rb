require 'rails_helper'

RSpec.describe "Languages management", :type => :request do

  let(:user) { FactoryGirl.create(:user) }

  let(:headers) { {HTTP_X_USER_EMAIL: user.email, HTTP_X_USER_TOKEN: user.authentication_token, HTTP_ACCEPT: 'application/json'} }
  let(:no_headers) { {HTTP_ACCEPT: 'application/json'} }

  let!(:french) { FactoryGirl.create(:language, name: 'French')  }
  let!(:english) { FactoryGirl.create(:language, name: 'English')  }
  let!(:japanease) { FactoryGirl.create(:language, name: 'Japanease')  }
  let(:french_params) {{language_id: french.id, spoken: true, written: true, level: "intermediate"}}
  let(:english_params) {{language_id: english.id, spoken: true, written: true, level: "fluent"}}
  let!(:first_lang){ FactoryGirl.create(:user_language, french_params.merge({user_id: user.id})) }
  let!(:second_lang){ FactoryGirl.create(:user_language, english_params.merge({user_id: user.id})) }

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

  describe 'POST /api/v1/languages' do
    context 'non authenticated user' do
      it 'return warning msg' do
        post '/api/v1/languages', {}, no_headers
        expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
        expect(response.status).to eq 401
      end
    end
    context 'authenticated user' do
      context 'valid input' do
        it 'return success msg' do
          post '/api/v1/languages', {language: french_params }, headers
          expect(response_json['message']).to eq('Successfully saved language')
          expect(response.status).to eq 200
        end
      end

      context 'invalid input' do
        it 'returns error msg' do
          post '/api/v1/languages', {language: {language_id: english.id } }, headers
          expect( response_json['errors'].keys ).to include('level')
          expect(response.status).to eq 401
        end
      end
    end
  end


  describe 'GET /api/v1/user/languages' do
    context 'non authenticated user' do
      it 'return warning msg' do
        get '/api/v1/user/languages', {}, no_headers
        expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
        expect(response.status).to eq 401
      end
    end
    context 'authenticated user' do
      it "returns list of user languages" do
        get '/api/v1/user/languages', {}, headers
        expect(response_json['languages'].size).to eq(2)
        expect(response.status).to eq 200
      end
    end
  end

  describe 'PUT /api/v1/user/languages/:id' do
    context 'non authenticated user' do
      it 'return warning msg' do
        put "/api/v1/languages/#{first_lang.id}", {}, no_headers
        expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
        expect(response.status).to eq 401
      end
    end
    context 'authenticated user' do
      context 'valid input' do
        it 'returns success message' do
          put "/api/v1/languages/#{first_lang.id}", {language: {level: 'fluent', written: false}}, headers
          expect(response_json['message']).to eq('Successfully updated language')
          expect(response.status).to eq 200
        end
      end
      context 'invalid input' do
        it 'returns error message' do
          put "/api/v1/languages/#{first_lang.id}", {language: {level: nil, spoken: nil, written: nil}}, headers
          expect( response_json['errors'].keys ).to include('level')
          expect(response.status).to eq 401
        end
      end
    end
  end

  describe 'DELETE /api/v1/languages/:id' do
    context 'non authenticated user' do
      it 'return warning msg' do
        delete "/api/v1/languages/#{first_lang.id}", {}, no_headers
        expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
        expect(response.status).to eq 401
      end
    end
    context 'authenticated user' do
      it 'return warning msg' do
        delete "/api/v1/languages/#{first_lang.id}", {}, headers
        expect(response_json['message']).to eq('Successfully deleted language')
        expect(response.status).to eq 200
      end
    end

  end
end
