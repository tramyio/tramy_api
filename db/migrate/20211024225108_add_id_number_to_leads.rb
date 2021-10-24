class AddIdNumberToLeads < ActiveRecord::Migration[6.0]
  def change
    add_column :leads, :id_number, :string
  end
end
