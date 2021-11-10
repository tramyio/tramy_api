# frozen_string_literal: true

class Chat < ApplicationRecord
  belongs_to :lead
  belongs_to :account, optional: true # When chat is not assigned to an agent

  scope :recently_updated, -> { order(updated_at: :desc) }
  scope :unattended, -> { where(account_id: nil) }

  # TODO: after_commit :validate_window

  # TODO: Add note when chat is initialized

  # def validate_window

  # end

  def first_agent_message
    chat_data['messages'].find { |message| message['from'].include?('@') }
  end

  def first_lead_message
    chat_data['messages'].find { |message| !message['from'].include?('@') }
  end
end
