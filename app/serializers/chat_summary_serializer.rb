class ChatSummarySerializer
  include JSONAPI::Serializer
  attributes :lead_id, :chat_data
end
