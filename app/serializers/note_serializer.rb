# frozen_string_literal: true

class NoteSerializer
  include JSONAPI::Serializer
  attributes :content, :created_at
end
