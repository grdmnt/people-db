class Location < ApplicationRecord
  has_many :person_locations
  has_many :people, through: :person_locations

  validates :name, format: { without: /\b[a-z]+\b/, message: 'should be title cased' }
end
