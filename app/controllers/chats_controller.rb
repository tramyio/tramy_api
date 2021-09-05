# frozen_string_literal: true

class ChatsController < ApplicationController
  # TODO: Destroy chat should not delete chat per se, should only delete list of messages

  before_action :set_chat, only: %i[show update destroy]

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

  # DELETE /chats/1
  # def destroy
  #   @chat.destroy
  # end

  def create_message(phone = '51972186137', message = 'Hola, mi nombre es Deyvi')
    lead = Lead.find_by(phone: phone)
    response = HTTParty.post(
      'https://waba-sandbox.360dialog.io/v1/messages',
      headers: { 'Content-Type' => 'application/json', 'D360-API-KEY' => 'aDlgxf_sandbox' },
      body: {
        "recipient_type": 'individual',
        "to": phone,
        "type": 'text',
        "text": {
          "body": message
        }
      }.to_json
    )

    if response.code.eql? 201
      tramy_account_message = { "from": phone, "type": 'text', "text": { "body": message } }
      lead.chat.chat_data['messages'] << tramy_account_message
      lead.chat.save
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_chat
    @chat = Chat.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def chat_params
    params.require(:chat).permit(:lead_id, :account_id, :chat_data)
  end
end
