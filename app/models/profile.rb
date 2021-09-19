# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user

  validates :first_name, length: { maximum: 100 }
  validates :last_name, length: { maximum: 100 }
  validates :logo_url, allow_blank: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  delegate :account, to: :user, prefix: true
end
