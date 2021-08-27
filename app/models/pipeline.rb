# frozen_string_literal: true

class Pipeline < ApplicationRecord
  has_many :stages, dependent: :destroy # When pipeline is destroyed, its stages will also be destroyed

  belongs_to :organization
end
