class AddWhatsappWindowToChats < ActiveRecord::Migration[6.0]
  def change
    add_column :chats, :whatsapp_window, :boolean
  end
end
