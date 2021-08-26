class Chat < ApplicationRecord
  has_many :notes

  belongs_to :lead
  belongs_to :account, optional: true # For recently created chat
end
