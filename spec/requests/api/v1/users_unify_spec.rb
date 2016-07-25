describe Api::V1::UsersController do
  let(:no_headers) { {'HTTP_ACCEPT': 'application/json'} }

  describe 'GET /api/v1/unify' do
    let(:user_1) { FactoryGirl.create(:user, user_name: 'Thomas', mentor: true) }
    let(:user_2) { FactoryGirl.create(:user, user_name: 'Anders') }
    let(:user_3) { FactoryGirl.create(:user, user_name: 'Kalle') }
    let(:user_4) { FactoryGirl.create(:user, user_name: 'Sam', mentor: true) }
    let(:user_5) { FactoryGirl.create(:user, user_name: 'Otto') }
    let(:headers) { {'HTTP_X_USER_EMAIL': user_1.email, 'HTTP_X_USER_TOKEN': user_1.authentication_token, 'HTTP_ACCEPT': 'application/json'} }

    before do
      user_1.update(skill_list: 'java-script, testing, ruby')
      user_2.update(skill_list: 'java-script, java, html')
      user_3.update(skill_list: 'java, html')
      user_4.update(skill_list: 'testing, ruby')
      user_5.update(skill_list: 'java-script, testing, ruby')
    end

    it 'should require authentication' do
      get "/api/v1/unify/#{user_1.id}", params: nil, headers: no_headers
      expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
      expect(response.status).to eq 401
    end

    describe 'by skills' do
      it 'should return list of users' do
        get "/api/v1/unify/#{user_1.id}", params: nil, headers: headers
        expected_response = [{user: {id: user_5.id,
                                     user_name: user_5.user_name,
                                     created_at: user_5.created_at,
                                     skills: user_5.skill_list.sort,
                                     profile: api_v1_user_url(user_5)}
                             },
                             {user: {id: user_2.id,
                                     user_name: user_2.user_name,
                                     created_at: user_2.created_at,
                                     skills: user_2.skill_list.sort,
                                     profile: api_v1_user_url(user_2)}
                             }]
        expect(response_json['matches']).to eq JSON.parse(expected_response.to_json)
      end
    end

    describe 'by location and skills' do

      before do
        user_1.update(latitude: '57.708870', longitude: '11.97456') #Gothenburg, Sweden
        user_2.update(latitude: '57.708870', longitude: '11.97456') #Gothenburg, Sweden
        user_3.update(latitude: '57.708870', longitude: '11.97456') #Gothenburg, Sweden
        user_4.update(latitude: '53.551085', longitude: '9.993682') #Hamburg, Germany
        user_5.update(latitude: '53.551085', longitude: '9.993682') #Hamburg, Germany
      end

      it 'should return list of users' do
        get "/api/v1/unify/#{user_1.id}", params: {location: true}, headers: headers

        expected_response = [{user: {id: user_2.id,
                                     user_name: user_2.user_name,
                                     created_at: user_2.created_at,
                                     skills: user_2.skill_list.sort,
                                     profile: api_v1_user_url(user_2)}
                             }]
        expect(response_json['matches']).to eq JSON.parse(expected_response.to_json)
      end

      it 'should not return a mentor when mentor requests to unify' do
        user_2.update(mentor: true)
        get "/api/v1/unify/#{user_1.id}", params: {location: true}, headers: headers
        expect(response_json['matches']).to be_empty
      end

    end
  end
end