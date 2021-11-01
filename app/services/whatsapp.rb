# frozen_string_literal: true

class Whatsapp < ApplicationService
  attr_reader :user, :to, :type, :message, :options # to: @chat.lead.phone

  # rubocop:disable Lint/MissingSuper
  def initialize(user, to, type, message, options = {})
    @user = user
    @to = to
    @type = type
    @message = message
    @options = options
  end
  # rubocop:enable Lint/MissingSuper

  def call
    case whatsapp_api_response.code
    when 201
      { json: updated_lead_messages, status: :created }
    when 403
      { json: I18n.t('http_response.403.message'), status: whatsapp_api_response.code }
    else
      { json: I18n.t('http_response.other.message'), status: whatsapp_api_response.code }
    end
  end

  def whatsapp_api_response
    @whatsapp_api_response ||= HTTParty.post(
      'https://waba.360dialog.io/v1/messages',
      headers: headers,
      body: payload(type).to_json
    )
  end

  def headers
    { 'Content-Type': 'application/json',
      'D360-API-KEY': user.organization.provider_api_key }
  end

  def payload(type)
    case type
    when 'text'
      {
        recipient_type: 'individual',
        to: to,
        type: 'text',
        text: {
          body: message
        }
      }
    when 'template'
      {
        to: to,
        type: 'template',
        template: message
      }
    when 'image'
      {
        to: to,
        type: 'image',
        image: message
      }
    when 'document'
      {
        to: to,
        type: 'document',
        document: message
      }
    end
  end

  def updated_lead_messages
    lead = Lead.find_by(phone: to, organization: user.organization)

    lead.update_messages!(formatted_lead_message)
  end

  def formatted_lead_message
    case type
    when 'text'
      base_lead_message.merge!(
        {
          text: { body: message }
        }
      )
    when 'template'
      base_lead_message.merge!(
        {
          template: { body: options[:template] } # TODO: Remove dependancy of options
        }
      )
    when 'image'
      base_lead_message.merge!(
        {
          image: message
        }
      )
    when 'document'
      base_lead_message.merge!(
        {
          document: message
        }
      )
    else
      {
        id: 'type_error',
        from: user.email || 'Desconocido',
        text: { body: 'Este mensaje no se enviará a tu cliente, contacta a soporte@tramy.io' },
        type: 'text',
        timestamp: Time.now.to_i.to_s
      }
    end
  end

  def base_lead_message
    { id: JSON.parse(whatsapp_api_response.body)['messages'][0]['id'],
      from: user.email || 'Desconocido',
      type: type,
      timestamp: Time.now.to_i.to_s }
  end
end
