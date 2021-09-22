# frozen_string_literal: true

class AccountSerializer
  include JSONAPI::Serializer
  attributes :full_name, :email, :role, :active

  attribute :full_name do |object|
    object&.user&.profile&.full_name
  end

  attribute :email do |object|
    object&.user&.email
  end
end
