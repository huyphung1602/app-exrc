require 'csv'

class ImportJob < ApplicationJob

  InterComStruct = Struct.new(:name, :siren, :form)
  ComStruct = Struct.new(:name, :code_insee, :population, :inter_siren)

  class << self
    def perform_now(csv)
      csv = generate_to_text(csv)
      header = true
      intercommunalities = []
      communes = []

      CSV.parse(csv)  do |row|
        if header
          header = false
          next
        end

        array = row.first.split("\;")

        communes << commune_structure(array)

        unless intercommunalities.map(&:name).include?(array[2])
          intercommunalities << intercommunality_structure(array)
        end
      end

      create_intercommunalities(intercommunalities)
      create_communes(communes)
    end

    private

    def commune_structure(array)
      ComStruct.new(
        array[8],
        array[6],
        array[9],
        array[1]
      )
    end

    def intercommunality_structure(array)
      InterComStruct.new(
        array[2],
        array[1],
        array[3].slice(0, 3).downcase
      )
    end

    def create_communes(communes)
      communes.each do |commune|
        create_commune(commune)
      end
    end

    def create_commune(commune)
      intercommunality_id = Intercommunality.find_by(siren: commune.inter_siren).id
      Commune.new(
        name: commune.name,
        code_insee: commune.code_insee,
        population: commune.population,
        intercommunality_id: intercommunality_id
      ).save!
    end

    def create_intercommunalities(intercommunalities)
      intercommunalities.each do |intercommunality|
        create_intercommunality(intercommunality)
      end
    end

    def create_intercommunality(intercommunality)
      Intercommunality.new(
        name: intercommunality.name,
        siren: intercommunality.siren,
        form: intercommunality.form
      ).save!
    end

    def generate_to_text(csv)
      IO::read(csv, col_sep: ";", encoding: "ISO8859-1:utf-8").scrub('')
    end
  end
end