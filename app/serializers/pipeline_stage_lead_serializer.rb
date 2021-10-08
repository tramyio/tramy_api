# frozen_string_literal: true

class PipelineStageLeadSerializer
  include JSONAPI::Serializer

  attribute :id, :name

  attribute :stages do |object|
    StageLeadSerializer.new(object.stages).serializable_hash[:data]
  end
end
