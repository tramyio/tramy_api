class CreateSetups < ActiveRecord::Migration[6.0]
  def change
    create_table :setups do |t|
      t.string :domain
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
