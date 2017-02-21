class Api::V1::ConversationsController < ApplicationController
  def index

  end

  def get_all_conversations
    @user = User.find_by_token(params['token'])
    if @user
      @conversations = Conversation.where("user_id = ? OR receiver_id = ?", @user.id, @user.id)
    end
    
    render :json => @conversations, :include => {:user => {:only => :email}}
  end

  def show
    @conversation = Conversation.find(params[:id])
    render :json => @conversation, :include => {
                                     :user => { :only => [:email, :token] },
                                     :receiver => { :only => [:email, :token] },
                                     :messages => { :only => [:content, :user_id]}
                                   }
  end

  def create
    context = {
      success: false
    }
    user = User.find_by_token(params[:token])
    receiver = User.find_by_email(params[:email])
    status = params[:status]
    subject = params[:subject]
    content = params[:content]

    @conversation = Conversation.new({user_id: user.id, receiver_id: receiver.id, status: status, subject: subject})

    if @conversation.save
      @message = @conversation.messages.create({content: params[:content], user_id: user.id})
      context['success'] = true
      context['message'] = "conversation save"
    end

    render :json => context
  end

  def send_message
    context = { success: false }
    token = params[:token]
    conversation_id = params[:conversation_id]
    content = params[:content]
    user = User.find_by_token(token)
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.create({content: params[:content], user_id: user.id})
    if @message
      context['success'] = true
      context['message'] = 'message sent'
    end

    render :json => @message
  end
end
