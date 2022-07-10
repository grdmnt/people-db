FactoryBot.define do
  factory :person do
    first_name { "Luke" }
    last_name { "Skywalker" }
    species { "Human" }
    gender { "Male" }
    weapon { "Lightsaber~!@@@" }
    vehicle { "X-wing Starfighter" }
  end
end
