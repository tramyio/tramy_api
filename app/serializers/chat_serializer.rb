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

  attribute :unanswered_messages do |object|
    index_reverse = object.chat_data['messages'].reverse.index do |message_hash|
      message_hash['from'].include? '@'
    end || object.chat_data['messages'].size
    index = object.chat_data['messages'].size - index_reverse - 1
    unanswered_messages = object.chat_data['messages'].size - index - 1
    unanswered_messages
  end
end
