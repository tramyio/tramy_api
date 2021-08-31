# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :chats

  belongs_to :user

  # When the account does not belong to any organization
  belongs_to :organization, optional: true

  validates :active, inclusion: [true, false]

  def activate
    self.active = true
  end

  # TODO: Define roles for Account model (https://github.com/tramyio/tramy_api/issues/3)
  # TODO: Define condition for account.active = false (Payment? Banished?)
end
