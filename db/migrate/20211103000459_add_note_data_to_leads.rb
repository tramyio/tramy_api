class AddNoteDataToLeads < ActiveRecord::Migration[6.0]
  def change
    add_column :leads, :note_data, :jsonb
  end
end
