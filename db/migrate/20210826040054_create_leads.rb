class CreateLeads < ActiveRecord::Migration[6.0]
  def change
    create_table :leads do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.references :stage, null: true, foreign_key: true

      t.timestamps
    end
  end
end
