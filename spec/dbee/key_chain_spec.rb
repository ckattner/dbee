# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Dbee::KeyChain do
  let(:key_paths) do
    [
      'z.b.c.d.e',
      'b.c.s',
      'a',
      'b.c.s',
      123,
      Dbee::KeyPath.get('44.55.66'),
      'a'
    ]
  end

  let(:out_of_order_key_paths) do
    [
      Dbee::KeyPath.get('44.55.66'),
      Dbee::KeyPath.get('44.55.66'),
      Dbee::KeyPath.get('44.55.66'),
      Dbee::KeyPath.get('b.c.s'),
      Dbee::KeyPath.get(123),
      Dbee::KeyPath.get('z.b.c.d.e'),
      Dbee::KeyPath.get('44.55.66'),
      Dbee::KeyPath.get('a')
    ]
  end

  subject { described_class.new(key_paths) }

  describe '#initialize' do
    it 'sets key_path_set correctly' do
      expect(subject.key_path_set).to eq(out_of_order_key_paths.to_set)
    end

    it 'sets ancestor_path_set correctly' do
      expected = out_of_order_key_paths.map(&:ancestor_paths).flatten.to_set

      expect(subject.ancestor_path_set).to eq(expected)
    end
  end

  specify 'equality compares unique key_paths' do
    chain1 = described_class.new(key_paths)
    chain2 = described_class.new(out_of_order_key_paths)

    expect(chain1).to eq(chain2)
    expect(chain1).to eql(chain2)
  end

  specify '#hash compares unique key_path hashes' do
    chain1 = described_class.new(key_paths)
    chain2 = described_class.new(out_of_order_key_paths)

    expect(chain1.hash).to eq(chain2.hash)
    expect(chain1.hash).to eql(chain2.hash)
  end

  describe '#ancestor_path?' do
    it 'returns true when passed in ancestor_path exists' do
      %w[z z.b z.b.c z.b.c.d b b.c 44 44.55].each do |example|
        expect(subject.ancestor_path?(example)).to be true
      end
    end

    it 'returns false when passed in ancestor_path does not exist' do
      %w[z.b.c.d.e matt nick sam.nick A Z].each do |example|
        expect(subject.ancestor_path?(example)).to be false
      end
    end
  end
end
