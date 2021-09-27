# frozen_string_literal: true

class PipelineSerializer
  include JSONAPI::Serializer

  attributes :name, :organization_id

  attributes :stages do |pipeline|
    StageSerializer.new(pipeline.stages).serializable_hash[:data]
  end
end
