module Api::V1::MailboxDoc
  extend Apipie::DSL::Concern

  api :post, '/v1/mailbox/conversations/compose', 'Create a conversation'
  formats %w(json)
  header :HTTP_ACCEPT, 'application/json', required: true
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  description 'Start a conversation with a user'
  param :receiver_id, Integer, required: true
  param :subject, String, required: true
  param :message, String, required: true
  example %q(
  Request:
  {
    "receiver_id": 11,
    "subject" : "Yo yo!",
    "message": "Wanna hang out?"
  }

  Response:
  {
  "message": "success"
  }

)

  def compose
  end

  api :GET, '/api/v1/mailbox/conversations/messages_count', 'Show nbr of messages'
  description 'Returns nbr of total and unread messages'
  formats %w(json)
  header :HTTP_ACCEPT, 'application/json', required: true
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  example %q(
  Response:
  {
    "messages_count": 2,
    "unread_messages_count": 1
  }
)

  def messages_count
  end

  api :post, '/v1/mailbox/conversations/reply', 'Reply to a conversation'
  description 'Allow current user to reply to a conversation'
  formats %w(json)
  header :HTTP_ACCEPT, 'application/json', required: true
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  param :conversation_id, Integer, required: true
  param :receiver_id, Integer, required: true
  param :subject, String, desc: 'optional by default it will inherit the conversation subject'
  param :message, String, required: true
  example %q(
  Request:
  {
    "conversation_id": 1,
    "receiver_id": 3, 
    "subject": "Answer",
    "message": "I'll be there in 10 mn"
  }

  Response:
  {
    "message": "success"
  }
)

  def reply
  end

  api :GET, '/v1/mailbox/conversations', 'List user\' conversations '
  description 'List all conversations for current user'
  formats %w(json)
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  example %q(
  Response:

{
  "conversations": [
    {
      "id": 2,
      "subject": "Meeting!",
      "created_at": "2016-04-03T06:39:16.654Z",
      "from": {
        "id": 2,
        "user_name": "Miss Ted Stroman"
      },
      "messages": [
        {
          "body": "Test message",
          "sent": "2016-04-03T06:39:16.654Z",
          "sender": "Miss Ted Stroman"
        }
      ]
    },
    {
      "id": 1,
      "subject": "Yo yo!",
      "created_at": "2016-04-03T05:55:31.245Z",
      "from": {
        "id": 3,
        "user_name": "Kade Powlowski"
      },
      "messages": [
        {
          "body": "I'll be there in 10 mn",
          "sent": "2016-04-03T06:30:15.671Z",
          "sender": "MB"
        },
        {
          "body": "Wanna hang out?",
          "sent": "2016-04-03T05:55:31.245Z",
          "sender": "Kade Powlowski"
        }
      ]
    }
  ]
}
  
  )
  def inbox
  end

  api :post, '/v1/mailbox/conversations/update', 'Mark converstation as read'
  description 'Allow current user to mark conversation as read'
  formats %w(json)
  header 'X-User-Email', 'email', required: true
  header 'X-User-Token', 'authentication token', required: true
  example %q(
  Request:
  {
    "id": 2
  }

  Response:
  {
    "massage": "success"
  }
  )
  def update
  end
end
