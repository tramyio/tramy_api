class CreatePipelines < ActiveRecord::Migration[6.0]
  def change
    create_table :pipelines do |t|
      t.string :name
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
