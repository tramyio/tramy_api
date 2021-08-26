class Pipeline < ApplicationRecord
  has_many :stages
  
  belongs_to :organization
end
