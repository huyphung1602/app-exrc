require 'roar/decorator'
require 'roar/json'

class ApplicationRepresenter < Roar::Decorator
  include Roar::JSON
end