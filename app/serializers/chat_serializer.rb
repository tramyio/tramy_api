# frozen_string_literal: true

class ChatSerializer
  include JSONAPI::Serializer

  attributes :id, :last_message

  attribute :lead, &:lead

  attribute :last_message do |object|
    object.chat_data['messages'].last
  end

  attribute :attended_by do |object|
    object&.account&.user&.profile
  end

  attribute :current_stage do |object|
    object&.lead&.stage
  end
end
