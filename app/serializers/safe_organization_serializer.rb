class SafeOrganizationSerializer
  include JSONAPI::Serializer
  attributes :id, :phone, :address, :domain
  # warning: do not expose provider_api_key !
end
