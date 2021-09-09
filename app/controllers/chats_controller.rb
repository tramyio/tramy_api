# frozen_string_literal: true

class ChatsController < ApplicationController
  # TODO: Destroy chat should not delete chat per se, should only delete list of messages
  # TODO: Assigning chat to an agent
  # TODO: Add D360-API-KEY for every Tramy's customer
  # TODO: Serialize chat index to show only newest message
  # TODO: Check that update method only re-assign chat to one of my organization mates

  before_action :authenticate_user!, only: %i[new_message]
  before_action :set_chat, only: %i[show update new_message destroy]
  before_action :set_organization, only: %i[new_message]

  # GET /chats
  def index
    @chats = Chat.recently_updated

    render json: @chats
  end

  # GET /chats/1
  def show
    render json: @chat
  end

  # POST /chats
  def create
    @chat = Chat.new(chat_params)

    if @chat.save
      render json: @chat, status: :created, location: @chat
    else
      render json: @chat.errors, status: :unprocessable_entity
    end
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
                 'D360-API-KEY': @organization.provider_api_key },
      body: {
        recipient_type: 'individual',
        to: @chat.lead.phone,
        type: 'text' || params[:type],
        text: {
          body: params[:message]
        }
      }.to_json
    )

    if response.code.eql? 201
      lead = Lead.find_by(phone: @chat.lead.phone)
      tramy_account_message = { 'from': params[:phone], 'type': 'text' || params[:type],
                                'text': { 'body': params[:message] } }
      lead.chat.chat_data['messages'] << tramy_account_message
      lead.chat.save
      render json: lead.chat.chat_data
    else
      render json: 'No se pudo enviar el mensaje al destinatario'
    end
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

  def set_organization
    @organization = current_user.account.organization
  end
end
