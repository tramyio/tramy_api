# frozen_string_literal: true

class ChatShowSerializer
  include JSONAPI::Serializer

  attributes :id, :chat_data

  attribute :lead, &:lead

  attribute :attended_by do |object|
    object&.account&.user&.profile
  end

  attribute :current_stage do |object|
    object&.lead&.stage
  end
end
