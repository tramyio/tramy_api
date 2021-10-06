# frozen_string_literal: true

class LeadSummarySerializer
  include JSONAPI::Serializer
  attributes :name, :email, :phone, :attended_by

  attribute :attended_by do |object|
    ProfileSummarySerializer.new(object&.chat&.account&.user&.profile).serializable_hash[:data][:attributes]
  end
end
