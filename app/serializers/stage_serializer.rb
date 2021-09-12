class StageSerializer
  include JSONAPI::Serializer

  attributes :name, :pipeline_id
end
