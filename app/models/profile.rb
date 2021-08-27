# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user

  # TODO: Validate photo_url from external provider: Amazon, Firebase or GCP
end
