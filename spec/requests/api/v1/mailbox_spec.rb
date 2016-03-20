require 'rails_helper'

describe Api::V1::MailboxController do
  let(:sender) { FactoryGirl.create(:user, user_name: 'Thomas') }
  let(:receiver_1) { FactoryGirl.create(:user, user_name: 'Anders') }
  let(:receiver_2) { FactoryGirl.create(:user, user_name: 'Kalle') }

  let(:sender_headers) { {HTTP_X_USER_EMAIL: sender.email, HTTP_X_USER_TOKEN: sender.authentication_token, HTTP_ACCEPT: 'application/json'} }
  let(:receiver_1_headers) { {HTTP_X_USER_EMAIL: receiver_1.email, HTTP_X_USER_TOKEN: receiver_1.authentication_token, HTTP_ACCEPT: 'application/json'} }
  let(:receiver_2_headers) { {HTTP_X_USER_EMAIL: receiver_2.email, HTTP_X_USER_TOKEN: receiver_2.authentication_token, HTTP_ACCEPT: 'application/json'} }

  let(:no_headers) { {HTTP_ACCEPT: 'application/json'} }

  describe 'should require authentication' do
    let(:expected_response) { 'You need to sign in or sign up before continuing.' }

    it '#inbox' do
      get '/api/v1/mailbox/inbox', {}, no_headers
      expect(response_json['error']).to eq expected_response
      expect(response.status).to eq 401
    end

    it '#sent' do
      get '/api/v1/mailbox/sent', {}, no_headers
      expect(response_json['error']).to eq expected_response
      expect(response.status).to eq 401
    end

    it '#trash' do
      get '/api/v1/mailbox/trash', {}, no_headers
      expect(response_json['error']).to eq expected_response
      expect(response.status).to eq 401
    end
  end

  describe 'Inbox' do
    before do
      sender.send_message(receiver_1, 'first message', 'subject 1')
      receiver_1.send_message(receiver_2, 'second message', 'subject 2')
      receiver_1_conversation = receiver_1.mailbox.inbox.first
      receiver_1.reply_to_conversation(receiver_1_conversation, 'Reply body 1')
    end

    it 'displays conversations while displaying receivers inbox' do
      get '/api/v1/mailbox/inbox', {}, receiver_1_headers
      first_message = response_json['inbox'].first
      expect(first_message['subject']).to eq 'subject 1'
      expect(first_message['from']['user_name']).to eq 'Thomas'
      expect(first_message['messages'].count).to eq 2
    end

    it 'does not display conversation while displaying other users inbox' do
      get '/api/v1/mailbox/inbox', {}, receiver_2_headers
      first_message = response_json['inbox'].first
      expect(first_message['subject']).not_to eq 'subject 1'
      expect(first_message['from']['user_name']).not_to eq 'Thomas'
      expect(first_message['messages'].count).not_to eq 2
    end
  end

end