# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'
require 'fixtures/models'

describe Dbee::SchemaCompatibility do
  let(:model_hash_graph) do
    {
      'model1' => {
        relationships: [
          name: 'model2',
          constraints: [
            {
              type: 'reference',
              parent: 'id',
              name: 'model1_id'
            }
          ]
        ]
      },
      'model2' => nil
    }
  end
  let(:schema) { Dbee::Schema.new(model_hash_graph) }

  let(:model_hash_tree) do
    {
      name: 'model1',
      models: [
        {
          name: 'model2',
          constraints: [
            {
              type: 'reference',
              parent: 'id',
              name: 'model1_id'
            }
          ]
        }
      ]
    }
  end

  let(:model_tree) { Dbee::Model.make(model_hash_tree) }

  let(:query_hash) do
    {
      fields: [
        { key_path: :a }
      ]
    }
  end

  let(:query) { Dbee::Query.make(query_hash) }

  describe 'query parsing' do
    it 'passes through Dbee::Query instances' do
      expect(described_class.new(schema, query).query).to eq query
    end

    it 'creates a Dbee::Query from a query hash' do
      expect(described_class.new(schema, query_hash).query).to eq query
    end
  end

  describe 'tree based models' do
    it 'creates a schema from a hash model' do
      expect(described_class.new(model_hash_tree, query).schema).to eq schema
    end

    it 'creates a schema from a model' do
      expect(described_class.new(model_tree, query).schema).to eq schema
    end

    it 'returns a query with the "from" field equal to the name of the root model of the tree' do
      # Sanity check
      query = Dbee::Query.new(query_hash)
      expect(query.from).to be_nil

      query_with_from = Dbee::Query.new(query_hash.merge(from: model_tree.name))

      expect(described_class.new(model_tree, query).query).to eq query_with_from
    end
  end

  describe 'graph based models' do
    it 'creates a schema from a hash schema' do
      expect(described_class.new(model_hash_graph, query).schema).to eq schema
    end

    it 'passes through Dbee::Schema instances' do
      expect(described_class.new(schema, query).schema).to eq schema
    end

    it 'creates a schema from a Dbee::Base constant' do
      pending 'requires Dbee::Base to Schema support'
      model_constant = Models::Theater

      expect(described_class.new(model_constant, query).schema).to eq some_schema
    end
  end
end
