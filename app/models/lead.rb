# frozen_string_literal: true

class Lead < ApplicationRecord
  has_one :chat, dependent: :destroy # If the lead is destroyed, consequently the chat also.

  belongs_to :stage, optional: true # For recently created lead (non-assigned)

  scope :oldest_created, -> { order(created_at: :asc) }

  validates :email, allow_nil: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true

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
end
