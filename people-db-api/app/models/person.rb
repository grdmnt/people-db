class Person < ApplicationRecord
  has_many :person_affiliations, dependent: :destroy
  has_many :person_locations, dependent: :destroy

  has_many :affiliations, -> { order(:name) }, through: :person_affiliations
  has_many :locations, -> { order(:name) }, through: :person_locations

  validates :first_name, presence: true, format: { without: /\b[a-z]+\b/, message: 'should be title cased' }
  validates :last_name, presence: true, format: { without: /\b[a-z]+\b/, message: 'should be title cased' }
  validates :species, presence: true
  validates :gender, presence: true
  validates :affiliations, length: { minimum: 1 }

  validates_associated :affiliations, :locations

  def name
    "#{first_name} #{last_name}".strip
  end

  def as_json(_ = nil)
    attributes.merge(
      locations: locations.map(&:name).join(', '),
      affiliations: affiliations.map(&:name).join(', ')
    )
  end
end
