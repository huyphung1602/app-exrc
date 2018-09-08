class Street < ApplicationRecord
  has_many :street_communes
  has_many :communes, through: :street_communes

  validates :title, presence: true
  validates :from, numericality: true, allow_nil: true
  validates :to, numericality: { greater_than: :from }, allow_nil: true
end
