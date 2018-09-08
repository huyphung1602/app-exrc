class CommuneRepresenter < ApplicationRepresenter
  property :id
  property :name
  property :code_insee
  property :intercommunality_id, render_nil: true
  property :created_at
  property :updated_at
end
