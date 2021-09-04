# frozen_string_literal: true

module Hookdeck
  class MessagesController < ApplicationController
    def webhook
      lead = Lead.where(phone: phone_hook)
                 .first_or_create(phone: phone_hook, name: name_hook)
      lead.chat.chat_data['messages'] << message_hook
      lead.chat.save
      head :ok
    end

    def phone_hook
      params.dig(:messages, 0, :from)
    end

    def name_hook
      params.dig(:contacts, 0, :profile, :name)
    end

    def message_hook
      params.dig(:messages, 0).to_unsafe_h
    end
  end
end
