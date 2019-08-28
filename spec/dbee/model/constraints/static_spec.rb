# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Dbee::Model::Constraints::Static do
  context 'equality' do
    let(:config) { { name: 'type', value: 'general' } }

    subject { described_class.new(config) }

    describe '#initialize' do
      it 'requires either a name or parent' do
        expect { described_class.new }.to                         raise_error(ArgumentError)
        expect { described_class.new(name: '', parent: '') }.to   raise_error(ArgumentError)
        expect { described_class.new(name: nil, parent: nil) }.to raise_error(ArgumentError)
      end
    end

    specify '#hash produces same output as concatenated string hash of name and parent' do
      parent_hash   = "#{described_class.name}#{config[:name]}#{config[:parent]}".hash
      expected_hash = "#{parent_hash}#{config[:value]}".hash

      expect(subject.hash).to eq(expected_hash)
    end

    specify '#== and #eql? compare attributes' do
      object2 = described_class.new(config)

      expect(subject).to eq(object2)
      expect(subject).to eql(object2)
    end

    it 'returns false unless comparing same object types' do
      expect(subject).not_to eq(config)
      expect(subject).not_to eq(nil)
    end
  end
end
