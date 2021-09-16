# frozen_string_literal: true

module Hookdeck
  class MessagesController < ApplicationController
    skip_before_action :authenticate_user!

    def webhook
      if params.key?(:messages)
        # return if params.key?(:statuses) # Skip temporarily webhook statuses
        owner_organization = Organization.find_by(phone: organization_phone_hook)

        lead = Lead.where(phone: lead_phone_hook)
                   .first_or_create(organization: owner_organization, name: lead_name_hook)

        lead.chat.chat_data['messages'] << lead_message_hook.merge!(status: 'delivered',
                                                                    timestamp: lead_message_timestamp)
        lead.chat.save
        head :ok
      elsif params.key?(:statuses)
        lead = Lead.find_by(phone: lead_status_phone)
        lead.chat.chat_data['messages']
            .select { |msg| msg['id'] == lead_status_message_id }[0]['status'] = lead_status_name
        lead.chat.save
        head :ok
      end
    end

    # Status methods
    def lead_status_phone
      params.dig(:statuses, 0, :recipient_id)
    end

    def lead_status_message_id
      params.dig(:statuses, 0, :id)
    end

    def lead_status_name
      params.dig(:statuses, 0, :status)
    end

    # Message methods

    def lead_phone_hook
      params.dig(:messages, 0, :from)
    end

    def lead_name_hook
      params.dig(:contacts, 0, :profile, :name)
    end

    def lead_message_hook
      params.dig(:messages, 0).to_unsafe_h
    end

    def lead_message_timestamp
      params.dig(:messages, 0, :timestamp)
    end

    def organization_phone_hook
      params[:number]
    end
  end
end
