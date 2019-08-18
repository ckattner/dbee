# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Dbee::Providers::NullProvider do
  specify '#sql returns SELECT NULL' do
    provider  = described_class.new
    model     = { name: 'something' }
    query     = {}

    actual_sql = provider.sql(model, query)

    expect(actual_sql).to eq('SELECT NULL')
  end
end
