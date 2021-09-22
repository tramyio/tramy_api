# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user

  validates :first_name, length: { maximum: 100 }
  validates :last_name, length: { maximum: 100 }
  validates :photo_url, allow_nil: true, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  delegate :account, to: :user, prefix: true

  def full_name
    [first_name, last_name].select(&:present?).join(' ').titleize
  end
end
