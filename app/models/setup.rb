# frozen_string_literal: true

class Setup < ApplicationRecord
  belongs_to :organization

  # TODO: Validate domain should be a valid url
end
