class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.string :domain
      t.string :provider_api_key

      t.timestamps
    end
  end
end
