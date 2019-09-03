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

    let(:model_hash) do
      {
        name: 'something'
      }
    end

    let(:model) { Dbee::Model.make(model_hash) }

    let(:query_hash) do
      {
        fields: [
          { key_path: :a }
        ]
      }
    end

    let(:query) { Dbee::Query.make(query_hash) }

    it 'accepts a hash as a model and passes a Model instance to provider#sql' do
      expect(provider).to receive(:sql).with(model, query)

      described_class.sql(model_hash, query, provider)
    end

    it 'accepts a Dbee::Model instance as a model and passes a Model instance to provider#sql' do
      expect(provider).to receive(:sql).with(model, query)

      described_class.sql(model, query, provider)
    end

    it 'accepts a Dbee::Base constant as a model and passes a Model instance to provider#sql' do
      model_constant = Models::Theater

      expect(provider).to receive(:sql).with(model_constant.to_model(query.key_chain), query)

      described_class.sql(model_constant, query, provider)
    end

    it 'accepts a Dbee::Query instance as a query and passes a Query instance to provider#sql' do
      model = Models::Theater.to_model(query.key_chain)

      expect(provider).to receive(:sql).with(model, query)

      described_class.sql(model, query, provider)
    end

    it 'accepts a hash as a query and passes a Query instance to provider#sql' do
      model = Models::Theater.to_model(query.key_chain)

      expect(provider).to receive(:sql).with(model, query)

      described_class.sql(model, query_hash, provider)
    end
  end
end
