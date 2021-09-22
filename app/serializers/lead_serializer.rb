class LeadSerializer
  include JSONAPI::Serializer
  attributes :name, :email, :phone, :stage, :created_at, :organization_id
  attribute :stage do |object|
    object&.stage
  end
end