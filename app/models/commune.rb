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
end
