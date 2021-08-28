# frozen_string_literal: true

class Pipeline < ApplicationRecord
  # When pipeline is destroyed, its stages will also be destroyed
  has_many :stages, dependent: :destroy

  belongs_to :organization
end
