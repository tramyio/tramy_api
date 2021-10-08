# frozen_string_literal: true

class PipelineSummarySerializer
  include JSONAPI::Serializer

  attributes :id, :name
end
