class CreateChats < ActiveRecord::Migration[6.0]
  def change
    create_table :chats do |t|
      t.jsonb :chat_data
      t.references :lead, null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true

      t.timestamps
    end
  end
end