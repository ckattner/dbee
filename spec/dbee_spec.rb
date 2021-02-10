# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'
require 'fixtures/models'

describe Dbee do
  describe '#sql' do
    let(:provider) { Dbee::Providers::NullProvider.new }

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

    describe 'tree based models' do
      it 'accepts a hash as a model and passes a Schema instance to provider#sql' do
        expect(provider).to receive(:sql).with(schema, query)

        described_class.sql(model_hash_tree, query, provider)
      end

      it 'accepts a Dbee::Model instance and passes a Schema instance to provider#sql' do
        expect(provider).to receive(:sql).with(schema, query)

        described_class.sql(model_tree, query, provider)
      end

      it 'adds the "from" field to queries to be the root model of the tree'
    end

    describe 'graph based models' do
      it 'accepts a hash as a model and passes a Schema instance to provider#sql' do
        expect(provider).to receive(:sql).with(schema, query)

        described_class.sql(model_hash_graph, query, provider)
      end

      it 'accepts a Dbee::Schema instance and passes a Schema instance to provider#sql' do
        expect(provider).to receive(:sql).with(schema, query)

        described_class.sql(schema, query, provider)
      end

      it 'accepts a Dbee::Base constant and passes a Model instance to provider#sql' do
        pending 'requires Dbee::Base to Schema support'
        model_constant = Models::Theater

        expect(provider).to receive(:sql).with(model_constant.to_model(query.key_chain), query)

        described_class.sql(model_constant, query, provider)
      end
    end

    it 'accepts a Dbee::Query instance as a query and passes a Query instance to provider#sql' do
      pending 'requires Dbee::Base to Schema support'
      model = Models::Theater.to_model(query.key_chain)

      expect(provider).to receive(:sql).with(schema, query)

      described_class.sql(model, query, provider)
    end

    it 'accepts a hash as a query and passes a Query instance to provider#sql' do
      pending 'requires Dbee::Base to Schema support'
      model = Models::Theater.to_model(query.key_chain)

      expect(provider).to receive(:sql).with(schema, query)

      described_class.sql(model, query_hash, provider)
    end
  end
end
