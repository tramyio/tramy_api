# frozen_string_literal: true

class LeadSerializer
  include JSONAPI::Serializer
  attributes :name, :email, :phone, :stage, :created_at, :organization_id

  attribute :created_at do |object|
    object.created_at.strftime('%d/%m/%Y %I:%M %P')
  end
end
