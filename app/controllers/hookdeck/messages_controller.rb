# frozen_string_literal: true

module Hookdeck
  class MessagesController < ApplicationController
    skip_before_action :authenticate_user!

    def webhook
      owner_organization = Organization.find_by(phone: organization_phone_hook)
      if params.key?(:messages)

        lead = Lead.where(phone: lead_phone_hook, organization: owner_organization)
                   .first_or_create(organization: owner_organization, name: lead_name_hook)

        lead.chat.chat_data['messages'] << lead_message_hook.merge!(status: 'delivered',
                                                                    timestamp: lead_message_timestamp)
      elsif params.key?(:statuses)

        lead = Lead.find_by(phone: whatsapp_params[:recipient_id], organization: owner_organization)
        lead.update_status_message(whatsapp_params[:id], whatsapp_params[:status])
      end
      lead.chat.save
      head :ok
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

    private

    def whatsapp_params
      params.require(:message).permit(statuses: %i[recipient_id id status]).to_h[:statuses][0]
    end
  end
end
