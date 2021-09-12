# frozen_string_literal: true

class PipelineSerializer
  include JSONAPI::Serializer

  attributes :stages do |pipeline|
    StageSerializer.new(pipeline.stages).serializable_hash[:data]
  end

  attributes :name, :organization_id
end
