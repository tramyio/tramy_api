# frozen_string_literal: true

class PipelineSerializer
  include JSONAPI::Serializer

  attributes :name, :organization_id

  attributes :stages, &:stages
end
