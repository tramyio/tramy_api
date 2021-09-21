# frozen_string_literal: true

class AddUniqueIndexToLeads < ActiveRecord::Migration[6.0]
  def change
    add_index :leads, %i[phone organization_id], unique: true
  end
end
