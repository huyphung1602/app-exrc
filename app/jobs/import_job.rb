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

      CSV.parse(csv) do |row|
        columns = row.first.split("\;")

        if header
          @col_struct = read_header(columns)
          header = false
          next
        end

        communes << commune_structure(columns, col_struct)

        unless intercommunalities.map(&:name).include?(columns[col_struct.nom_complet])
          intercommunalities << intercommunality_structure(columns, col_struct)
        end
      end

      create_intercommunalities(intercommunalities)
      create_communes(communes)
    end

    private
    attr_reader :col_struct

    def commune_structure(columns, col_struct)
      ComStruct.new(
        columns[col_struct.nom_com],
        columns[col_struct.insee],
        columns[col_struct.pop_total],
        columns[col_struct.siren_epci]
      )
    end

    def intercommunality_structure(columns, col_struct)
      InterComStruct.new(
        columns[col_struct.nom_complet],
        columns[col_struct.siren_epci],
        columns[col_struct.form_epci].slice(0, 3).downcase
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

    def read_header(columns)
      columns.each_with_object(OpenStruct.new).with_index do |(col_name, col_struct), index|
        col_struct[col_name] = index
      end
    end

    def csv_from_file_path(file_path)
      IO::read(file_path, col_sep: ";", encoding: "ISO8859-1:utf-8").scrub('')
    end
  end
end