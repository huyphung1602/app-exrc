class CommuneDecorator
  delegate :id, :name, :code_insee, :created_at, :updated_at, :intercommunality_id, to: :commune

  def initialize(commune)
    @commune = commune
  end

  private

  attr_reader :commune
end