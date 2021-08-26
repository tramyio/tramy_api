class Stage < ApplicationRecord
  has_many :leads

  belongs_to :pipeline
end
