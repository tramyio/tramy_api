# frozen_string_literal: true

class LeadSummarySerializer
  include JSONAPI::Serializer
  attributes :name, :email, :phone, :attended_by

  attribute :attended_by do |object|
    if object&.chat&.account.blank?
      object&.chat&.account
    else
      ProfileSummarySerializer.new(object&.chat&.account&.user&.profile).serializable_hash[:data][:attributes]
    end
  end
end
