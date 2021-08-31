# frozen_string_literal: true

class Chat < ApplicationRecord
  has_many :notes, dependent: :destroy # If the chat is destroyed, consequently the notes also.

  belongs_to :lead
  belongs_to :account, optional: true # When chat is not assigned to an agent

  scope :recently_updated, -> { order(updated_at: :desc) }

  after_commit :add_creation_note, on: :create

  def add_creation_note
    Note.create(chat: self, content: "Se inició la conversación. #{DateTime.now.tramy_format}")
  end
end
