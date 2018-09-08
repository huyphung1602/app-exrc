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

  def self.intercommunality_exist?(siren)
    where(siren: siren).exists?
  end

  def self.create_intercommunality!(data)
    return if intercommunality_exist?(data.siren)

    new.tap do |intercommunality|
      intercommunality.name = data.name
      intercommunality.siren = data.siren
      intercommunality.form = data.form
      intercommunality.name = data.name
      intercommunality.save!
    end
  end

  def communes_hash
    communes.each_with_object({}) do |commune, communes_hash|
      communes_hash[commune.code_insee] = commune.name
    end
  end

  def population
    sum = 0
    communes.each do |commune|
      if commune.population
        sum += commune.population
      end
    end
    sum
  end
end
