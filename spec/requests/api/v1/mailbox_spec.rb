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
      get '/api/v1/mailbox/conversations', {}, no_headers
      expect(response_json['error']).to eq expected_response
      expect(response.status).to eq 401
    end

    it '#trash' do
      get '/api/v1/mailbox/conversations/trash', {}, no_headers
      expect(response_json['error']).to eq expected_response
      expect(response.status).to eq 401
    end

    it '#messages_count' do
      get '/api/v1/mailbox/conversations/messages_count', {}, no_headers
      expect(response_json['error']).to eq expected_response
      expect(response.status).to eq 401
    end

    it '#compose' do
      post '/api/v1/mailbox/conversations/compose', {}, no_headers
      expect(response_json['error']).to eq expected_response
      expect(response.status).to eq 401
    end

    it '#reply' do
      post '/api/v1/mailbox/conversations/compose', {}, no_headers
      expect(response_json['error']).to eq expected_response
      expect(response.status).to eq 401
    end
  end

  describe 'Conversations' do
    before do
      sender.send_message(receiver_1, 'first message', 'subject 1')
      receiver_1.send_message(sender, 'second message', 'subject 2')
      receiver_1.send_message(receiver_2, 'second message', 'subject 2')
      receiver_1_conversation = receiver_1.mailbox.inbox.first
      receiver_1.reply_to_conversation(receiver_1_conversation, 'Reply body 1')
    end

    it 'displays conversations while displaying receivers inbox' do
      get '/api/v1/mailbox/conversations', {}, sender_headers
      first_message = response_json['conversations'].first
      expect(first_message['subject']).to eq 'subject 1'
      expect(first_message['from']['user_name']).to eq 'Anders'
      expect(first_message['messages'].count).to eq 2
    end

    it 'does not display conversation while displaying other users inbox' do
      get '/api/v1/mailbox/conversations', {}, receiver_2_headers
      first_message = response_json['conversations'].first
      expect(first_message['subject']).not_to eq 'subject 1'
      expect(first_message['from']['user_name']).not_to eq 'Thomas'
      expect(first_message['messages'].count).not_to eq 2
    end
  end

  describe 'Compose' do

    it 'sends a message with valid settings' do
      post '/api/v1/mailbox/conversations/compose', {receiver_id: receiver_1.id, subject: 'Yo yo!', message: 'Wanna hang out?'}, sender_headers
      expect(response_json['message']).to eq 'success'
    end

    it 'rejects a message without receiver' do
      post '/api/v1/mailbox/conversations/compose', {receiver_id: 999999, subject: 'Yo yo!', message: 'Wanna hang out?'}, sender_headers
      expect(response_json['error']).to eq 'failed to create message'
    end

  end

  describe 'Reply' do
    before do
      receiver_1.send_message(sender, 'second message', 'subject 2')
      @conversation = sender.mailbox.conversations.first
    end

    it 'replies to  a message with valid settings' do
      post '/api/v1/mailbox/conversations/reply', {conversation_id: @conversation.id, receiver_id: receiver_1.id, subject: 'Yo yo!', message: 'Wanna hang out?'}, sender_headers
      expect(response_json['message']).to eq 'success'
    end

    it 'rejects a reply without conversation' do
      post '/api/v1/mailbox/conversations/reply', {conversation_id: 999999, subject: 'Yo yo!', message: 'Wanna hang out?'}, sender_headers
      expect(response_json['error']).to eq 'failed to create message'
    end

  end

  describe 'Message count' do

    before do
      sender.send_message(receiver_1, 'first message', 'subject 1')
      receiver_1.send_message(sender, 'second message', 'subject 2')
      @receiver_1_conversation = sender.mailbox.inbox.first
      sender.reply_to_conversation(@receiver_1_conversation, 'Reply body 1')
    end

    it 'returns message count' do
      get '/api/v1/mailbox/conversations/messages_count', {}, sender_headers
      expect(response_json['messages_count']).to eq 2
      expect(response_json['unread_messages_count']).to eq 1
    end

    describe 'marks a conversation as read' do
      before do
        post '/api/v1/mailbox/conversations/update', {id: @receiver_1_conversation.id}, sender_headers
      end

      it '#is_read? returns true' do
        expect(@receiver_1_conversation.is_read? sender).to eq true
      end

      it '#unread_messages_count returns 0' do
        get '/api/v1/mailbox/conversations/messages_count', {}, sender_headers
        expect(response_json['messages_count']).to eq 2
        expect(response_json['unread_messages_count']).to eq 0
      end
    end


  end

end