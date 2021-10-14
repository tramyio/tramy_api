# frozen_string_literal: true

class ChatsController < ApplicationController
  # TODO: Destroy chat should not delete chat per se, should only delete list of messages
  # TODO: Create a method that decides if it will send a new_message or will open_conversation

  before_action :set_chat, only: %i[show update new_message list_notes append_note destroy]

  def index
    @chats = if params[:query].blank?
               Chat.joins(:lead)
                   .merge(Lead.where(organization_id: current_user.organization))
                   .recently_updated
             else
               query = params[:query].to_s.downcase
               Chat.joins(:lead)
                   .merge(Lead.where(organization_id: current_user.organization)
                              .where('lower(name) LIKE :query or lower(email) LIKE :query or phone LIKE :query',
                                     query: "%#{query}%"))
                   .recently_updated
             end

    render json: ChatSerializer.new(@chats).serializable_hash[:data], status: :ok
  end

  def assigned_to_me
    @chats = Chat.where(account: current_user.account)
    render json: ChatSerializer.new(@chats).serializable_hash[:data], status: :ok
  end

  def not_assigned
    @chats = Chat.joins(:lead).merge(Lead.where(organization_id: current_user.organization)).unattended
    render json: ChatSerializer.new(@chats).serializable_hash[:data], status: :ok
  end

  def show
    return unless permitted_chat(@chat)

    render json: ChatShowSerializer.new(@chat).serializable_hash[:data]
  end

  def update
    assigned_agent = Account.find(params[:account_id])
    return unless assigned_agent.organization == current_user.organization

    if @chat.update(chat_params)
      render json: ChatSerializer.new(@chat).serializable_hash[:data][:attributes]
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def new_message
    return unless permitted_chat(@chat)

    response = Whatsapp.call(current_user, @chat.lead.phone, params[:type], params[:message])

    render response
  end

  def list_notes
    # TODO: Add Pundit
    render json: NoteSerializer.new(@chat.notes).serializable_hash[:data]
  end

  def append_note
    note = Note.new(content: params[:content], chat: @chat)
    if note.save
      render json: note, status: :created
    else
      render json: I18n.t('chat.note.failed'), status: :unprocessable_entity
    end
  end

  def open_conversation
    # TODO: Method open conversation when 24-hour window has been closed.
  end

  def permitted_chat(chat)
    current_user.organization == chat.lead.organization
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chat
    @chat = Chat.find(params[:id])
  end

  # Neccesary params for agent reassignment
  def chat_params
    params.require(:chat).permit(:account_id, :chat_data)
  end
end
