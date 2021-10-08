# frozen_string_literal: true

class ProfileSummarySerializer
  include JSONAPI::Serializer
  attributes :first_name, :last_name
end
