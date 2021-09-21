class SafeOrganizationSerializer
  include JSONAPI::Serializer
  attributes :name, :phone, :address, :domain
end
