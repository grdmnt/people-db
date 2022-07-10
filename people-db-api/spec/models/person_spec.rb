require 'rails_helper'

RSpec.describe Person, type: :model do
  describe '#valid?' do
    let(:person) { build(:person, weapon: nil, vehicle: nil) }

    before do
      person.affiliations.build
    end

    context 'when valid' do
      it 'is valid' do
        expect(person).to be_valid
      end
    end

    context 'without first name' do
      before do
        person.first_name = ''
      end

      it 'is invalid' do
        expect(person).to be_invalid
      end
    end

    context 'with first name not title cased' do
      before do
        person.first_name = 'jar Jar'
      end

      it 'is invalid' do
        expect(person).to be_invalid
      end
    end

    context 'without last name' do
      before do
        person.last_name = ''
      end

      it 'is invalid' do
        expect(person).to be_invalid
      end
    end

    context 'with last name not title cased' do
      before do
        person.last_name = 'binks'
      end

      it 'is invalid' do
        expect(person).to be_invalid
      end
    end

    context 'without species' do
      before do
        person.species = ''
      end

      it 'is invalid' do
        expect(person).to be_invalid
      end
    end

    context 'without gender' do
      before do
        person.gender = ''
      end

      it 'is invalid' do
        expect(person).to be_invalid
      end
    end

    context 'without any affiliations' do
      before do
        person.affiliations = []
      end

      it 'is invalid' do
        expect(person).to be_invalid
      end
    end
  end
end
