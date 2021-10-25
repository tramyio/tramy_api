# frozen_string_literal: true

class LeadSerializer
  include JSONAPI::Serializer
  attributes :name, :id_number, :email, :phone, :stage, :attended_by, :created_at, :organization_id

  attribute :attended_by do |object|
    object&.chat&.account&.user&.profile
  end

  attribute :created_at do |object|
    object.created_at.strftime('%d/%m/%Y %I:%M %P')
  end
end
