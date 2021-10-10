class StageLeadSerializer
  include JSONAPI::Serializer

  attributes :name

  attribute :leads do |object|
    LeadSummarySerializer.new(object.leads.recently_updated).serializable_hash[:data]
  end
end