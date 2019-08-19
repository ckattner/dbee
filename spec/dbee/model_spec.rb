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

  describe '#ancestors' do
    let(:yaml_entities) { yaml_fixture('models.yaml') }

    let(:entity_hash) { yaml_entities['Theaters, Members, and Movies'] }

    subject { described_class.make(entity_hash) }

    specify 'returns proper models' do
      members = subject.models.first

      expected_plan = {
        'members' => members
      }

      plan = subject.ancestors(%w[members])

      expect(plan).to eq(expected_plan)
    end

    specify 'returns proper multi-level models' do
      members       = subject.models.first
      demos         = members.models.first
      phone_numbers = demos.models.first

      expected_plan = {
        'members' => members,
        'members.demos' => demos,
        'members.demos.phone_numbers' => phone_numbers
      }

      plan = subject.ancestors(%w[members demos phone_numbers])

      expect(plan).to eq(expected_plan)
    end

    specify 'equality compares attributes' do
      config = yaml_fixture('models.yaml')['Theaters, Members, and Movies']

      model1 = described_class.make(config)
      model2 = described_class.make(config)

      expect(model1).to eq(model2)
      expect(model1).to eql(model2)
    end
  end

  context 'README examples' do
    specify 'code-first and configuration-first models are equal' do
      config = yaml_fixture('models.yaml')['Readme']

      config_model = described_class.make(config)

      expect(config_model).to eq(ReadmeDataModels::Practices.to_model)
    end
  end
end
