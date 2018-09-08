class Commune < ApplicationRecord
  belongs_to :intercommunality, optional: true
  has_many :street_communes
  has_many :streets, through: :street_communes

  validates :name, presence: true
  validates :code_insee,
    presence: true,
    format: { with: /\A[0-9]+\z/},  length: { is: 5 }

  def self.search(search_name)
    search_name.gsub!(/%/,'\%')
    where("name LIKE :search_name", search_name: "%#{search_name.downcase}%")
  end

  def self.to_hash
    all.each_with_object({}) do |commune, communes_hash|
      communes_hash[commune.code_insee] = commune.name
    end
  end

  def self.commune_exist?(code_insee)
    where(code_insee: code_insee).exists?
  end

  def self.create_commune!(data)
    return if commune_exist?(data.code_insee)

    intercommunality_id = Intercommunality.find_by(siren: data.inter_siren).id

    new.tap do |commune|
      commune.name = data.name
      commune.code_insee = data.code_insee
      commune.population = data.population
      commune.intercommunality_id = intercommunality_id
      commune.save!
    end
  end

  def update_content!(code_insee, name)
    self.code_insee = code_insee
    self.name = name
    self.save!
  end
end
