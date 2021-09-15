# frozen_string_literal: true

class ChatsController < ApplicationController
  # TODO: Destroy chat should not delete chat per se, should only delete list of messages
  # TODO: Assigning chat to an agent
  # TODO: Serialize chat index to show only newest message
  # TODO: Check that update method only re-assign chat to one of my organization mates
  # TODO: Create a method that decides if it will send a new_message or will open_conversation

  before_action :set_chat, only: %i[show update new_message list_notes destroy]

  # GET /chats
  def index
    @chats = Chat.joins(:lead).merge(Lead.where(organization_id: current_user.organization)).recently_updated
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

  # GET /chats/1
  def show
    # TODO: Add Pundit
    render json: ChatShowSerializer.new(@chat).serializable_hash[:data]
  end

  # PATCH/PUT /chats/1
  def update
    if @chat.update(chat_params)
      render json: @chat
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
  end

  def new_message
    response = HTTParty.post(
      'https://waba-sandbox.360dialog.io/v1/messages',
      headers: { 'Content-Type': 'application/json',
                 'D360-API-KEY': current_user.organization.provider_api_key },
      body: {
        recipient_type: 'individual',
        to: @chat.lead.phone,
        type: 'text' || params[:type],
        text: {
          body: params[:message]
        }
      }.to_json
    )

    case response.code
    when 201
      lead = Lead.find_by(phone: @chat.lead.phone)

      tramy_agent_message = { id: JSON.parse(response.body)['messages'][0]['id'],
                              from: current_user.email || 'Desconocido',
                              text: { body: params[:message] },
                              type: 'text' || params[:type],
                              timestamp: Time.now.to_i.to_s }

      lead.chat.chat_data['messages'] << tramy_agent_message
      lead.chat.save

      render json: tramy_agent_message, status: :created
    when 403
      render json: 'No tiene permiso para comunicarse con este numero', status: :forbidden
    else
      render json: 'No se pudo enviar el mensaje al destinatario', status: :unprocessable_entity
    end
  end

  def open_conversation
    # TODO: Method open conversation when 24-hour window has been closed.
  end

  def list_notes
    # TODO: Add Pundit
    render json: @chat.notes
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
