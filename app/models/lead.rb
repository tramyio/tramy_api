# frozen_string_literal: true

class Lead < ApplicationRecord
  has_one :chat

  belongs_to :stage, optional: true # For recently created lead
end
