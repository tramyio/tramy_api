class StageLeadSerializer
  include JSONAPI::Serializer

  attributes :name

  attribute :leads do |object|
    LeadSummarySerializer.new(object.leads).serializable_hash[:data]
  end
end