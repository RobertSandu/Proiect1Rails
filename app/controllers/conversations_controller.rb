class ConversationsController < ApplicationController
  helper_method :mailbox, :conversation

  #seteaza mailboxul userului curent daca este nil
   before_action :mailbox

   #creaza o noua conversatie (post)
  def create
    #idurile userilor care o sa primeasca mesajul
    recipient_emails = conversation_params(:recipients).split(',')
    recipients = User.where(email: recipient_emails).all

    conversation = current_user.send_message(recipients, *conversation_params(:body, :subject)).conversation
  end

  #preia conversatiile userlui curent (setate de metoda mailbox)
  #si foloseste gem-ul will paginate
  def index
    @conversations ||= @mailbox.inbox.page(params[:page]).per_page(25)
    @conversationscount ||= current_user.mailbox.inbox.all
  end


  def reply
    current_user.reply_to_conversation(conversation, params[:body])
    redirect_to conversation_path(@conversation)
  end

 

  def show
    @conversation ||= @mailbox.conversations.find(params[:id])
    conversation.mark_as_read(current_user)
  end


  private

  def mailbox
    @mailbox ||= current_user.mailbox
  end

  def conversation
    @conversation ||= mailbox.conversations.find(params[:id])
  end
end