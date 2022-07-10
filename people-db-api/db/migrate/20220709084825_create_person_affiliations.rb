class CreatePersonAffiliations < ActiveRecord::Migration[7.0]
  def change
    create_table :person_affiliations do |t|
      t.references :person, null: false, foreign_key: true
      t.references :affiliation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
