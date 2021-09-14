# frozen_string_literal: true

class Account < ApplicationRecord
  enum role: {
    admin: 0,
    owner: 1,
    agent: 2
  }

  # TODO: Define condition for account.active = false (Payment? Banished?)
  has_many :chats

  belongs_to :user

  # When the account does not belong to any organization
  belongs_to :organization, optional: true

  validates :active, inclusion: [true, false]

  def activate
    self.active = true
  end
end
