# frozen_string_literal: true

class PipelineSerializer
  include JSONAPI::Serializer

  attributes :name, :organization_id

  attribute :stages do |object|
    object.stages.select(:id, :name, :pipeline_id)
  end
end
