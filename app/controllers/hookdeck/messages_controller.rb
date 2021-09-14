# frozen_string_literal: true

module Hookdeck
  class MessagesController < ApplicationController
    # TODO: Check if incoming payload include messages' keys, then execute incoming webhooks logic
    # TODO: Check if incoming payload include statuses' keys, then execute status webhook logic
    skip_before_action :authenticate_user!

    def webhook
      return if params.key?(:statuses) # Skip temporarily webhook statuses

      owner_organization = Organization.find_by(phone: organization_phone_hook)

      lead = Lead.where(phone: lead_phone_hook)
                 .first_or_create(phone: lead_phone_hook, name: lead_name_hook, organization: owner_organization)

      lead.chat.chat_data['messages'] << lead_message_hook
      lead.chat.save
      head :ok
    end

    def lead_phone_hook
      params.dig(:messages, 0, :from)
    end

    def lead_name_hook
      params.dig(:contacts, 0, :profile, :name)
    end

    def lead_message_hook
      params.dig(:messages, 0).to_unsafe_h.reject! { |key| key == 'id' }
    end

    def organization_phone_hook
      params[:number]
    end
  end
end
