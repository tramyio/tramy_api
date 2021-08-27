# frozen_string_literal: true

class Lead < ApplicationRecord
  has_one :chat

  belongs_to :stage, optional: true # For recently created lead (non-assigned)

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true
end
