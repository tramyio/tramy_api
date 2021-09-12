# frozen_string_literal: true

module Hookdeck
  class MessagesController < ApplicationController
    # TODO: Check if incoming payload include messages' keys, then execute incoming webhooks logic
    # TODO: Check if incoming payload include statuses' keys, then execute status webhook logic
    skip_before_action :authenticate_user!

    def webhook
      return if params.key?(:statuses) # Skip temporarily statuses

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
      params.dig(:messages, 0).to_unsafe_h.reject! { |key| key == 'id' }
    end
  end
end
