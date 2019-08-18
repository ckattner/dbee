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

    let(:query) { {} }

    it 'accepts a hash as a model and passes a Model instance to provider#sql' do
      model = { name: 'something' }

      expect(provider).to receive(:sql).with(Dbee::Model.make(model), Dbee::Query.make(query))

      described_class.sql(model, query, provider)
    end

    it 'accepts a Dbee::Model instance as a model and passes a Model instance to provider#sql' do
      model = Dbee::Model.make(name: 'something')

      expect(provider).to receive(:sql).with(Dbee::Model.make(model), Dbee::Query.make(query))

      described_class.sql(model, query, provider)
    end

    it 'accepts a Dbee::Base constant as a model and passes a Model instance to provider#sql' do
      model = Models::Theaters

      expect(provider).to receive(:sql).with(model.to_model, Dbee::Query.make(query))

      described_class.sql(model, query, provider)
    end

    it 'accepts a Dbee::Query instance as a query and passes a Query instance to provider#sql' do
      model = Models::Theaters
      query = Dbee::Query.make(query)

      expect(provider).to receive(:sql).with(model.to_model, Dbee::Query.make(query))

      described_class.sql(model, query, provider)
    end

    it 'accepts a hash as a query and passes a Query instance to provider#sql' do
      model = Models::Theaters

      expect(provider).to receive(:sql).with(model.to_model, Dbee::Query.make(query))

      described_class.sql(model, query, provider)
    end
  end
end
