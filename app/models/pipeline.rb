# frozen_string_literal: true

class Pipeline < ApplicationRecord
  has_many :stages

  belongs_to :organization
end
