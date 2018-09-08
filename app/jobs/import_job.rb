require 'csv'

class ImportJob < ApplicationJob

  InterStruct = Struct.new(:name, :siren, :form)

  class << self
    def perform_now(csv)
      csv = generate_to_text(csv)
      header = true
      intercommunalities = []

      CSV.parse(csv)  do |row|
        if header
          header = false
          next
        end

        array = row.first.split("\;")

        unless intercommunalities.map(&:name).include?(array[2])
          intercommunalities << intercommunality_structure(array)
        end
      end

      create_intercommunalities(intercommunalities)
    end

    private

    def intercommunality_structure(array)
      InterStruct.new(
        array[2],
        array[1],
        array[3].slice(0, 3).downcase
      )
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