# frozen_string_literal: true

class Account < ApplicationRecord
  has_many :chats

  belongs_to :user
  belongs_to :organization

  enum role: {
    owner: 0, # Total access
    admin: 1 # Home + Chat + Clients + Funnel + Team (view-only) + Setup (except: my business)

    # TODO: Add sales and suppport roles
    # sales: 2, # Home + Chat + Clients + Funnel + Team (view-only) + Setup (only: my profile)
    # support: 3 # Home + Chat + Clients + Team (view-only) + Setup (only: my profile)
  }
end
