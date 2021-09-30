# frozen_string_literal: true

class ProfileSerializer
  include JSONAPI::Serializer
  attributes :first_name, :last_name, :email, :photo_url, :organization_name

  attribute :email do |object|
    object&.user&.email
  end

  attribute :organization_name do |object|
    object&.user&.account&.organization&.name
  end
end
