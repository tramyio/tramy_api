# frozen_string_literal: true

class Organization < ApplicationRecord
  # TODO: Restrict organization to max 3 accounts
  has_one :setup
  has_many :accounts
  has_many :pipelines

  validates :phone_number, uniqueness: true

  after_commit :create_then_associate_setup, on: :create

  def create_then_associate_setup
    Setup.create(organization: self)
  end
end
