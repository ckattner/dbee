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
    let(:query_hash) do
      {
        fields: [
          { key_path: :a }
        ]
      }
    end

    let(:query) { Dbee::Query.make(query_hash) }

    it 'requires the query to have a from model' do
      expect do
        described_class.sql(Dbee::Schema.new({}), query, provider)
      end.to raise_error(ArgumentError, /query requires a from model name/)
    end
  end
end
