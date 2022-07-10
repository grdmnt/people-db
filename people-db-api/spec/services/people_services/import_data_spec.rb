# frozen_string_literal: true

require 'rails_helper'

describe PeopleServices::ImportData do
  describe '.call' do
    subject(:call_service) { described_class.call(params) }

    let(:params) do
      {
        csv_file: double('CSV File')
      }
    end

    let(:csv_raw) do
      [
        {
          'Name' => 'Darth Vadar', 'Location' => 'Death Star, Tatooine', 'Species' => 'Human',
          'Gender' => 'Male', 'Affiliations' => 'Sith', 'Weapon' => 'Lightsaber',
          'Vehicle' => 'Tiefighter'
        },
        {
          'Name' => 'Sheev Palpatine', 'Location' => 'Naboo', 'Species' => 'Human', 'Gender' => 'Male',
          'Affiliations' => 'Galactic Republic', 'Weapon' => 'Lightsaber', 'Vehicle' => nil
        }
      ]
    end

    before do
      allow(CSV).to receive(:read).and_return(csv_raw)
    end

    context 'when with all valid data' do
      it 'is successful' do
        expect(call_service).to be_a_success
      end

      it 'returns two people objects' do
        expect(call_service.imported_data.size).to eq 2
      end

      it 'does not return any failed rows' do
        expect(call_service.failed_rows).to be_empty
      end

      it 'creates two people records' do
        expect { call_service }.to change { Person.count }.by(2)
      end
    end

    context 'when with some invalid data' do
      let(:csv_raw) do
        [
          {
            'Name' => 'Darth Vadar', 'Location' => 'Death Star, Tatooine', 'Species' => 'Human',
            'Gender' => 'Male', 'Affiliations' => 'Sith', 'Weapon' => 'Lightsaber',
            'Vehicle' => 'Tiefighter'
          },
          {
            'Name' => 'Sheev Palpatine', 'Location' => 'Naboo', 'Species' => 'Human', 'Gender' => 'Male',
            'Affiliations' => nil, 'Weapon' => 'Lightsaber', 'Vehicle' => nil
          }
        ]
      end

      it 'is successful' do
        expect(call_service).to be_a_success
      end

      it 'returns one person object' do
        expect(call_service.imported_data.size).to eq 1
      end

      it 'returns failed row' do
        expected_failed_row = [
          [2, 'Sheev Palpatine']
        ]

        expect(call_service.failed_rows).to eq expected_failed_row
      end

      it 'creates one person record' do
        expect { call_service }.to change { Person.count }.by(1)
      end
    end

    context 'when with sample data' do
      let(:csv_raw) do
        CSV.read('spec/support/test-data.csv', headers: true).map(&:to_h)
      end

      let(:expected_failed_rows) do
      end

      it 'is successful' do
        expect(call_service).to be_a_success
      end

      it 'returns 12 people objects' do
        expect(call_service.imported_data.size).to eq 12
      end

      it 'returns failed rows' do
        expected_failed_rows = [
          [2, 'Chewbacca'],
          [3, 'yoda'],
          [11, 'R2-D2'],
          [13, 'Boba Fett'],
          [14, 'Rey'],
          [16, 'C-3PO']
        ]

        expect(call_service.failed_rows).to eq expected_failed_rows
      end

      it 'creates 12 people records' do
        expect { call_service }.to change { Person.count }.by(12)
      end
    end
  end
end
