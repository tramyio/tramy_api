# frozen_string_literal: true

class Lead < ApplicationRecord
  # If the lead is destroyed, consequently the chat also.
  has_one :chat, dependent: :destroy

  # For recently created lead (non-assigned)
  belongs_to :stage, optional: true

  validates :email, allow_nil: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true

  after_commit :create_then_associate_chat, on: :create

  def create_then_associate_chat
    Chat.create(lead: self)
  end

  def assigned_account
    chat.account
  end

  def assigned_account?
    !assigned_account.nil?
  end
end
