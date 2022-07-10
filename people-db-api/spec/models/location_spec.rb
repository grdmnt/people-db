require 'rails_helper'

RSpec.describe Location, type: :model do
  describe '#valid?' do
    let(:location) { build(:location) }

    context 'with valid attributes' do
      it 'is valid' do
        expect(location).to be_valid
      end
    end

    context 'with non title cased name' do
      before do
        location.name = 'death Star'
      end

      it 'is invalid' do
        expect(location).to be_invalid
      end
    end
  end
end
