json.inbox(@inbox) do |conversation|
  json.id conversation.id
  json.subject conversation.subject
  json.created_at conversation.created_at
  json.from do
    json.id conversation.original_message.sender.id
    json.user_name conversation.original_message.sender.user_name
  end
  json.messages(conversation.messages) do |message|
    json.body message.body
    json.sent message.created_at
    json.sender message.sender.user_name
  end

end