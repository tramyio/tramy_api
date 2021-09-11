# frozen_string_literal: true

class ChatSerializer
  include JSONAPI::Serializer
  attributes :id, :last_message

  attribute :account_assigned, &:account
  attribute :lead, &:lead

  attribute :last_message do |object|
    object.chat_data['messages'].last
  end

  # attribute :agent_assigned do |object|
  #   object.account.user.profile
  # end
end
