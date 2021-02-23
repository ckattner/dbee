# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'
require 'fixtures/models'

describe Dbee::Model do
  describe '#initialize' do
    specify 'name is set properly' do
      config = { name: 'theaters' }

      model = described_class.make(config)

      expect(model.name).to eq(config[:name])
    end

    specify 'table defaults to name' do
      config = { name: 'theaters' }

      model = described_class.make(config)

      expect(model.table).to eq(config[:name])
    end

    specify 'table can be explicitly set' do
      config = { name: 'favorite_comedy_movies', table: 'movies' }

      model = described_class.make(config)

      expect(model.table).to eq(config[:table])
    end

    specify 'models are set properly' do
      config = {
        name: 'theaters',
        models: [
          { name: 'members' },
          { name: 'passes' }
        ]
      }

      expected_association_names = config[:models].map { |a| a[:name] }

      model = described_class.make(config)

      association_names = model.models.map(&:name)

      expect(association_names).to eq(expected_association_names)
    end
  end

  describe '#to_s' do
    it 'is represented by the model name' do
      expect(described_class.new(name: 'foo').to_s).to eq 'foo'
    end
  end

  describe '#ancestors' do
    let(:yaml_entities) { yaml_fixture('models.yaml') }

    let(:entity_hash) { yaml_entities['Theaters, Members, and Movies'] }

    subject { described_class.make(entity_hash) }

    specify 'returns proper models' do
      members = subject.models.first

      expected_plan = {
        %w[members] => members
      }

      plan = subject.ancestors!(%w[members])

      expect(plan).to eq(expected_plan)
    end

    specify 'returns proper multi-level models' do
      members       = subject.models.first
      demos         = members.models.first
      phone_numbers = demos.models.first

      expected_plan = {
        %w[members] => members,
        %w[members demos] => demos,
        %w[members demos phone_numbers] => phone_numbers
      }

      plan = subject.ancestors!(%w[members demos phone_numbers])

      expect(plan).to eq(expected_plan)
    end
  end

  describe 'equality' do
    let(:config) { yaml_fixture('models.yaml')['Theaters, Members, and Movies'] }
    let(:model1) { described_class.make(config) }
    let(:model2) { described_class.make(config) }

    subject { described_class.make(config) }

    specify 'equality compares attributes' do
      expect(model1).to eq(model2)
      expect(model1).to eql(model2)
    end

    it 'returns false unless comparing same object types' do
      expect(subject).not_to eq(config)
      expect(subject).not_to eq(nil)
    end

    describe 'hash codes' do
      specify 'are equal when objects are equal' do
        expect(model1).to eq(model2)
        expect(model1.hash).to eq(model2.hash)
      end

      specify 'are not equal when objects are not equal' do
        different_model = described_class.new(name: :oddball)
        expect(model1).not_to eq(different_model)
        expect(model1.hash).not_to eq(different_model.hash)
      end
    end
  end
end
