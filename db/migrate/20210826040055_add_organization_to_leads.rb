class AddOrganizationToLeads < ActiveRecord::Migration[6.0]
  def change
    add_reference :leads, :organization, null: false, foreign_key: true
  end
end
