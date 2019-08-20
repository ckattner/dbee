# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Dbee::Query::Sorter do
  it 'should act as hashable' do
    expect(described_class).to respond_to(:make)
    expect(described_class).to respond_to(:array)
  end

  context '#initialize' do
    specify 'key_path is required' do
      expect { described_class.new(key_path: '') }.to   raise_error(ArgumentError)
      expect { described_class.new(key_path: nil) }.to  raise_error(ArgumentError)
      expect { described_class.new }.to                 raise_error(ArgumentError)
    end
  end

  context 'equality' do
    let(:config) { { key_path: 'a.b.c', direction: :descending } }

    subject { described_class.new(config) }

    specify '#hash produces same output as concatenated string hash of key_path and direction' do
      expect(subject.hash).to eq("#{config[:key_path]}#{config[:direction]}".hash)
    end

    specify '#== and #eql? compare attributes' do
      object2 = described_class.new(config)

      expect(subject).to eq(object2)
      expect(subject).to eql(object2)
    end
  end

  describe 'direction helpers' do
    context 'when direction is ascending' do
      let(:config) { { key_path: 'a.b.c' } }

      subject { described_class.new(config) }

      it '#ascending? is true' do
        expect(subject.ascending?).to be true
      end

      it '#descending? is false' do
        expect(subject.descending?).to be false
      end
    end

    context 'when direction is descending' do
      let(:config) { { key_path: 'a.b.c', direction: :descending } }

      subject { described_class.new(config) }

      it '#ascending? is false' do
        expect(subject.ascending?).to be false
      end

      it '#descending? is true' do
        expect(subject.descending?).to be true
      end
    end
  end
end