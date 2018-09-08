class Intercommunality < ApplicationRecord
  has_many :communes

  validates :name, presence: true, uniqueness: true
  validates :siren,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: /\A[0-9]+\z/}, length: { is: 9 }
  validates :form, inclusion: { in: %w(ca cu cc met) }

  before_validation do
    self.slug = name.parameterize if slug.nil? && name.present?
  end

  def communes_hash
    communes.each_with_object({}) do |commune, communes_hash|
      communes_hash[commune.code_insee] = commune.name
    end
  end
end
