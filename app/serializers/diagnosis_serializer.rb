class DiagnosisSerializer < ActiveModel::Serializer
  attributes :id, :name, :desc, :severity
end
