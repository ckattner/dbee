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
    specify 'name is required' do
      expect { described_class.new(name: '') }.to raise_error(ArgumentError)
      expect { described_class.new(name: nil) }.to  raise_error(ArgumentError)
      expect { described_class.new }.to             raise_error(ArgumentError)
    end
  end

  context 'equality' do
    let(:config) { { name: 'type' } }

    subject { described_class.new(config) }

    specify '#hash produces same output as string hash of name' do
      expect(subject.hash).to eq(config[:name].to_s.hash)
    end

    specify '#== and #eql? compares attributes' do
      object2 = described_class.new(config)

      expect(subject).to eq(object2)
      expect(subject).to eql(object2)
    end
  end
end
