# frozen_string_literal: true

class Lead < ApplicationRecord
  # TODO: Allow same lead can send message to many organizations (scope phone unique by each organization)
  has_one :chat, dependent: :destroy # If the lead is destroyed, consequently the chat also.

  belongs_to :stage, optional: true # For recently created lead (non-assigned)
  belongs_to :organization

  scope :recently_created, -> { order(created_at: :desc) }
  scope :recently_updated, -> { order(updated_at: :desc) }

  validates :email, allow_nil: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true, uniqueness: { scope: :organization_id }

  after_commit :create_then_associate_chat, on: :create

  def create_then_associate_chat
    Chat.create(lead: self, chat_data: { "messages": [] })
  end

  def assigned_account
    chat.account
  end

  def assigned_account?
    !assigned_account.nil?
  end

  def update_messages!(message)
    chat.chat_data['messages'] << message
    chat.save
    message
  end

  def update_status_message(message_id, status)
    chat.chat_data['messages'].find { |msg| msg['id'] == message_id }['status'] = status
  end

  def update_notes!(content, author)
    new_note = { content: content, author: author, timestamp: Time.now.to_i.to_s }
    update!(note_data: { "notes": [] }) if note_data.nil?
    note_data['notes'] << new_note
    save
  end
end
