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

describe Dbee::Model::Columns::Boolean do
  specify 'equality compares attributes' do
    config = {
      name: :a,
      nullable: false
    }

    column1 = described_class.make(config)
    column2 = described_class.make(config)

    expect(column1).to eq(column2)
    expect(column1).to eql(column2)
  end

  describe '#coerce' do
    context 'when not nullable and value is a string' do
      subject { described_class.make(name: :active, nullable: false) }

      %w[y Y yes YES Yes yEs t True TRUE T TrUe 1].each do |value|
        it "converts #{value} to true" do
          expect(subject.coerce(value)).to be true
        end
      end

      %w[n N no NO No nO f F FALSE 0 nil null Nil Null NULL NIL].each do |value|
        it "converts #{value} to true" do
          expect(subject.coerce(value)).to be false
        end
      end
    end

    context 'when nullable and value is a string' do
      subject { described_class.make(name: :active, nullable: true) }

      %w[y Y yes YES Yes yEs t True TRUE T TrUe 1].each do |value|
        it "converts #{value} to true" do
          expect(subject.coerce(value)).to be true
        end
      end

      %w[n N no NO No nO f F FALSE 0].each do |value|
        it "converts #{value} to true" do
          expect(subject.coerce(value)).to be false
        end
      end

      %w[nil null Nil Null NULL NIL].each do |value|
        it "converts #{value} to true" do
          expect(subject.coerce(value)).to be nil
        end
      end
    end
  end
end
