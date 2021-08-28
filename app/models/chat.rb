# frozen_string_literal: true

class Chat < ApplicationRecord
  # If the chat is destroyed, consequently the notes also.
  has_many :notes, dependent: :destroy

  belongs_to :lead

  # When chat is not assigned to an agent
  belongs_to :account, optional: true

  after_commit :add_creation_note, on: :create

  def add_creation_note
    Note.create(chat: self, content: "Se inició la conversación. #{DateTime.now.tramy_format}")
  end
end
