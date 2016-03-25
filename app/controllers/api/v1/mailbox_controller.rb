class Api::V1::MailboxController < ApiController
  before_action :set_user

  def inbox
    @inbox = @user.mailbox.conversations
    @active = :inbox
  end

  def compose
    receiver = User.find_by_id(params[:receiver_id])
    if receiver
      @user.send_message(receiver, params[:message], params[:subject])
      render json: {message: 'success'}
    else
      render json: {error: 'failed to create message'}
    end
  end

  def reply
    conversation = @user.mailbox.conversations.find{|conversation| conversation.id == params[:conversation_id].to_i }
    if conversation
      @user.reply_to_conversation(conversation, params[:message], params[:subject])
      render json: {message: 'success'}
    else
      render json: {error: 'failed to create message'}
    end
  end

  def update
    conversation = @user.mailbox.conversations(id: params[:id]).first
    if conversation.mark_as_read(@user)
      render json: {massage: 'success'}
    else
      render json: {error: 'something went wrong'}
    end

  end

  def trash
    @trash = @user.mailbox.trash
    @active = :trash
  end

  def set_user
    @user = User.find_by_authentication_token(params[:user_token])
  end


  def messages_count
    render json: {messages_count: @user.messages_count, unread_messages_count: @user.unread_messages_count}
  end
end