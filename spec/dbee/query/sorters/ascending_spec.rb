# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Dbee::Query::Sorters::Ascending do
  context 'equality' do
    let(:config) do
      { key_path: 'a.b.c' }
    end

    subject { described_class.new(config) }

    it 'returns true if instance class and key_paths are equal' do
      subject2 = described_class.new(config)

      expect(subject).to eq(subject2)
      expect(subject).to eql(subject2)
    end

    it 'returns false if instance class is different' do
      subject2 = Dbee::Query::Sorters::Descending.new(config)

      expect(subject).not_to eq(subject2)
      expect(subject).not_to eql(subject2)
    end

    it 'returns false if key_path is different' do
      subject2 = described_class.new(key_path: 'd.e.f')

      expect(subject).not_to eq(subject2)
      expect(subject).not_to eql(subject2)
    end
  end
end
