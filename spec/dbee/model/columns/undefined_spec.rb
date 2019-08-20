# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Dbee::Model::Columns::Undefined do
  let(:config) { { name: :some_column } }

  subject { described_class.make(config) }

  specify 'equality compares attributes' do
    column1 = described_class.make(config)
    column2 = described_class.make(config)

    expect(column1).to eq(column2)
    expect(column1).to eql(column2)
  end

  specify '#coerce returns value' do
    value = 'abc123'
    expect(subject.coerce(value)).to eq(value)
  end
end
