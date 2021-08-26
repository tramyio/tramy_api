# frozen_string_literal: true

class Organization < ApplicationRecord
  has_one :setup
  has_many :accounts
  has_many :pipelines

  validates :phone_number, uniqueness: true
end
