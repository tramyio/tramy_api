# frozen_string_literal: true

class Setup < ApplicationRecord
  # TODO: Validate domain should be a valid url
  belongs_to :organization
end
