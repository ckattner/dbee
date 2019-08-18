# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Dbee::Query do
  let(:config) do
    {
      fields: [
        { key_path: 'matt.nick.sam', display: 'some display' },
        { key_path: 'katie' },
        { key_path: 'jordan.pippen' }
      ],
      sorters: [
        { key_path: :sort_me },
        { key_path: :sort_me_too, direction: :descending }
      ],
      limit: 125
    }
  end

  subject { described_class.make(config) }

  specify '#eql? compares attributes' do
    expect(subject).to eq(described_class.make(config))
  end
end
