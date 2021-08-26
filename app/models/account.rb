# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :chats

  belongs_to :user
  belongs_to :organization
end
