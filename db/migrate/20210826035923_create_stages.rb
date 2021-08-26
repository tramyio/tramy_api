class CreateStages < ActiveRecord::Migration[6.0]
  def change
    create_table :stages do |t|
      t.string :name
      t.references :pipeline, null: false, foreign_key: true

      t.timestamps
    end
  end
end
