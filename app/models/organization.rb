# frozen_string_literal: true

class Organization < ApplicationRecord
  # TODO: Restrict organization to max 3 accounts
  # TODO: Encrypt provider_api_key (https://edgeguides.rubyonrails.org/active_record_encryption.html#declaration-of-encrypted-attributes)
  has_many :accounts, dependent: :destroy
  has_many :pipelines, dependent: :destroy

  # Fast access
  has_many :leads

  validates :phone, uniqueness: true, presence: true

  def activate_accounts
    accounts.update_all(active: true)
  end
end
