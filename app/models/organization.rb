# frozen_string_literal: true

class Organization < ApplicationRecord
  # TODO: Restrict organization to max 3 accounts
  # TODO: Encrypt provider_api_key (https://edgeguides.rubyonrails.org/active_record_encryption.html#declaration-of-encrypted-attributes)
  has_one :setup
  has_many :accounts
  has_many :pipelines

  validates :phone, uniqueness: true

  after_commit :create_then_associate_setup, on: :create

  def create_then_associate_setup
    Setup.create(organization: self)
  end
end
