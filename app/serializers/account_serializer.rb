class AccountSerializer
  include JSONAPI::Serializer
  attributes :id, :user_id, :organization_id, :role, :active
end
