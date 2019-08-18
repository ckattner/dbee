# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Dbee::Query::KeyPath do
  let(:key_path_string) { 'contacts.demographics.first' }

  subject { described_class.get(key_path_string) }

  specify '#initialize sets correct values' do
    expect(subject.value).to          eq(key_path_string)
    expect(subject.column_name).to    eq(key_path_string.split('.').last)
    expect(subject.ancestor_names).to eq(key_path_string.split('.')[0..-2])
  end

  specify '#hash is same as value.hash' do
    expect(subject.hash).to eq(key_path_string.hash)
  end

  specify '#to_s is same as value' do
    expect(subject.to_s).to eq(key_path_string)
  end

  specify 'equality compares to value' do
    expect(subject).to eq(key_path_string)
    expect(subject).to eql(key_path_string)
  end
end
