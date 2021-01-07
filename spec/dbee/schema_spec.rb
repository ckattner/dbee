# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'
require_relative '../fixtures/models'

describe Dbee::Schema do
  def make_model(model_name)
    raise "no model named '#{model_name}'" unless schema_config.key?(model_name)

    Dbee::Model.make((schema_config[model_name] || {}).merge('name' => model_name))
  end

  let(:model_name) do
    'Theaters, Members, and Movies Directed Graph Based with Nested Sub-models'
  end
  let(:schema_config) { yaml_fixture('models.yaml')[model_name] }

  let(:demographics_model) { make_model('demographics') }
  let(:members_model) { make_model('members') }
  let(:movies_model) { make_model('movies') }
  let(:phone_numbers_model) { make_model('phone_numbers') }
  let(:theaters_model) { make_model('theaters') }

  let(:subject) { described_class.new(schema_config) }

  it 'knows if two models are related' do
    # subject.write_to_graphic_file
    expect(subject.neighbors?(theaters_model, members_model)).to be(true)
    expect(subject.neighbors?(members_model, demographics_model)).to be(true)

    # Theaters and demographics related through members and are not direct neighbors.
    expect(subject.neighbors?(theaters_model, demographics_model)).to be(false)
  end

  describe '#expand_query_path' do
    specify 'one model case' do
      expect(subject.expand_query_path(%w[members])).to eq({ %w[members] => members_model })
    end

    specify 'two model case' do
      expected_plan = {
        %w[members] => members_model,
        %w[members movies] => movies_model
      }
      expect(subject.expand_query_path(%w[members movies])).to eq expected_plan
    end

    it 'traverses aliased models' do
      expected_plan = {
        %w[members] => members_model,
        %w[members demos] => demographics_model,
        %w[members demos phone_numbers] => phone_numbers_model
      }

      expect(subject.expand_query_path(%w[members demos phone_numbers])).to eq expected_plan
    end

    it 'raises an error given an unknown model' do
      expect { subject.expand_query_path(%w[bogus]) }.to raise_error Dbee::Model::ModelNotFoundError
    end

    it 'raises an error given an unknown path' do
      expect do
        subject.expand_query_path(%w[theaters demographics])
      end.to raise_error("model 'theaters' does not have a 'demographics' relationship")
    end
  end
end
