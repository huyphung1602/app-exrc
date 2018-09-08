require 'csv'

class ImportJob < ApplicationJob

  InterComStruct = Struct.new(:name, :siren, :form)
  ComStruct = Struct.new(:name, :code_insee, :population, :inter_siren)

  class << self
    def perform_now(csv)
      csv = csv_from_file_path(csv)
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
        Commune.create_commune!(commune)
      end
    end

    def create_intercommunalities(intercommunalities)
      intercommunalities.each do |intercommunality|
        Intercommunality.create_intercommunality!(intercommunality)
      end
    end

    def csv_from_file_path(file_path)
      IO::read(file_path, col_sep: ";", encoding: "ISO8859-1:utf-8").scrub('')
    end
  end
end