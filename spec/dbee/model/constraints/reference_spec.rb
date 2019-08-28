# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Dbee::Model::Constraints::Reference do
  context '#initialize' do
    specify 'parent is required' do
      expect { described_class.new(name: 'a', parent: '') }.to  raise_error(ArgumentError)
      expect { described_class.new(name: 'a', parent: nil) }.to raise_error(ArgumentError)
      expect { described_class.new(name: 'a') }.to raise_error(ArgumentError)
    end
  end

  context 'equality' do
    let(:config) { { name: 'id', parent: 'patient_id' } }

    subject { described_class.new(config) }

    specify '#hash produces same output as concatenated string hash of name and parent' do
      expect(subject.hash).to eq("#{config[:name]}#{config[:parent]}".hash)
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
