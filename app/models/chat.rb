# frozen_string_literal: true

class Chat < ApplicationRecord
  has_many :notes, dependent: :destroy # If the chat is destroyed, consequently the notes also.

  belongs_to :lead
  belongs_to :account, optional: true # When chat is not assigned to an agent

  scope :recently_updated, -> { order(updated_at: :desc) }
  scope :unattended, -> { where(account_id: nil) }

  after_commit :add_note, on: :create
  # TODO: after_commit :validate_window

  def add_note
    Note.create(chat: self, content: "Se inició la conversación. #{DateTime.now.tramy_format}")
  end

  # def validate_window

  # end

  # def last_lead_message

  # end
end
