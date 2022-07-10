# frozen_string_literal: true
module PeopleServices
  class ImportData < BaseService
    attr_accessor :csv

    def initialize(csv_file:)
      super

      self.csv = CSV.read(csv_file, headers: true)
    end

    def call
      people_objects = build_people_objects(csv)
      saved_objects = []
      failed_rows = []

      people_objects.each.with_index(1) do |person, i|
        if person.valid?
          person.save
          saved_objects << person
        else
          failed_rows << [i, csv[i - 1]['Name']]
        end
      end

      build_result(imported_data: saved_objects, failed_rows: failed_rows)
    end

    private

    def build_people_objects(csv)
      csv.map.with_index(1) do |row, i|
        person = build_person_object(row)
        build_locations_for_person(row, person)
        build_affiliations_for_person(row, person)

        person
      end
    end

    def build_person_object(row)
      names = row['Name']&.split(' ') || []
      last_name = names.pop&.strip
      first_name = names.join(' ')&.strip

      Person.new(
        first_name: first_name&.titlecase,
        last_name: last_name&.titlecase,
        species: row['Species']&.titlecase,
        gender: row['Gender']&.titlecase,
        weapon: row['Weapon']&.titlecase,
        vehicle: row['Vehicle']&.titlecase
      )
    end

    def build_locations_for_person(row, person)
      locations = row['Location'] || ''
      locations.split(',').map do |location|
        saved_location = Location.find_or_create_by(name: location.strip.titlecase)
        person.locations << saved_location
      end
    end

    def build_affiliations_for_person(row, person)
      affiliations = row['Affiliations'] || ''
      affiliations.split(',').map do |affiliation|
        saved_affiliation = Affiliation.find_or_create_by(name: affiliation.strip.titlecase)
        person.affiliations << saved_affiliation
      end
    end
  end
end