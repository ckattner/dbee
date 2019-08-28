# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Dbee::Model::Constraints::Base do
  it 'should act as hashable' do
    expect(described_class).to respond_to(:make)
    expect(described_class).to respond_to(:array)
  end

  context '#initialize' do
    it 'sets name correctly' do
      expect(described_class.new.name).to               eq('')
      expect(described_class.new(name: 123).name).to    eq('123')
      expect(described_class.new(name: 'abc').name).to  eq('abc')
    end

    it 'sets parent correctly' do
      expect(described_class.new.parent).to                 eq('')
      expect(described_class.new(parent: 123).parent).to    eq('123')
      expect(described_class.new(parent: 'abc').parent).to  eq('abc')
    end
  end

  context 'equality' do
    let(:config) do
      {
        name: 'NAME!',
        parent: 'PARENT!'
      }
    end

    subject { described_class.new(config) }

    specify '#hash produces same output as string hash of name' do
      expect(subject.hash).to eq("#{config[:name]}#{config[:parent]}".hash)
    end

    specify '#== and #eql? compares attributes' do
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
