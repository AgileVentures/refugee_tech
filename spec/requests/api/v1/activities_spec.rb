require 'rails_helper'

describe Api::V1::ActivitiesController do

  let(:fixture) { File.read('spec/fixtures/activity_feed.json') }
  let(:user) { FactoryGirl.create(:user) }
  let(:headers) { {'HTTP_X_USER_EMAIL': user.email, 'HTTP_X_USER_TOKEN': user.authentication_token, 'HTTP_ACCEPT': 'application/json'} }
  let(:no_headers) { {'HTTP_ACCEPT': 'application/json'} }

  before do
    allow(Api::V1::ActivityFeed).to receive(:get_fb_feed).and_return(JSON.parse(fixture))
  end

  it 'should require authentication' do
    get '/api/v1/activities', params: nil, headers: no_headers
    expect(response_json['error']).to eq 'You need to sign in or sign up before continuing.'
    expect(response.status).to eq 401
  end

  it 'should return a feed' do
    get '/api/v1/activities', params: nil, headers: headers
    expect(response_json['feed'].count).to eq 14
    expect(response_json['feed'].first['id']).to eq '1'
    expect(response.status).to eq 200
  end

  it 'activity type should be :facebook' do
    get '/api/v1/activities', params: nil, headers: headers
    expect(response_json['feed'].last['type']).to eq 'facebook'
  end

end