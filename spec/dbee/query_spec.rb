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
      filters: [
        { key_path: 'filter_me.a_little', value: 'something' },
        { key_path: 'matt.nick.sam', value: 'something' }
      ],
      limit: 125
    }
  end

  subject { described_class.make(config) }

  specify '#eql? compares attributes' do
    expect(subject).to eq(described_class.make(config))
  end

  describe '#initialize' do
    it 'should raise an ArgumentError if fields keyword is missing' do
      expect { described_class.new }.to raise_error(ArgumentError)
    end

    it 'should raise a NoFieldsError if no fields were passed in' do
      expect { described_class.new(fields: []) }.to raise_error(Dbee::Query::NoFieldsError)
    end

    it 'should remove duplicate filters (keep first instance)' do
      query_hash = {
        fields: [
          { key_path: 'a' }
        ],
        filters: [
          { key_path: 'a', value: 'something' },
          { key_path: 'b', value: 123 },
          { key_path: 'b', value: '123' },
          { key_path: 'c', value: nil },
          { key_path: 'c', value: '' },
          { key_path: 'd', value: 'r', type: :greater_than_or_equal_to },
          { key_path: 'd', value: 'r' },
          { key_path: 'e', value: [1, 2, 3] },
          { key_path: 'a', value: 'something' },
          { key_path: 'e', value: [1, 2, 3] }
        ]
      }

      expected_filters = Dbee::Query::Filters.array([
                                                      { key_path: 'a', value: 'something' },
                                                      { key_path: 'b', value: 123 },
                                                      { key_path: 'b', value: '123' },
                                                      { key_path: 'c', value: nil },
                                                      { key_path: 'c', value: '' },
                                                      {
                                                        key_path: 'd',
                                                        value: 'r',
                                                        type: :greater_than_or_equal_to
                                                      },
                                                      { key_path: 'd', value: 'r' },
                                                      { key_path: 'e', value: [1, 2, 3] }
                                                    ])

      expect(described_class.make(query_hash).filters).to eq(expected_filters)
    end

    it 'should remove duplicate sorters (keep first instance)' do
      query_hash = {
        fields: [
          { key_path: 'a' }
        ],
        sorters: [
          { key_path: 'a' },
          { key_path: 'b' },
          { key_path: 'c', direction: :descending },
          { key_path: '1' },
          { key_path: :a },
          { key_path: 1 },
          { key_path: 'c', direction: :descending }
        ]
      }

      expected_sorters = Dbee::Query::Sorter.array([
                                                     { key_path: 'a' },
                                                     { key_path: 'b' },
                                                     { key_path: 'c', direction: :descending },
                                                     { key_path: '1' }
                                                   ])

      expect(described_class.make(query_hash).sorters).to eq(expected_sorters)
    end
  end

  describe '#key_chain' do
    it 'should include filter, sorter, and field key_paths' do
      key_paths =
        config[:fields].map { |f| f[:key_path].to_s } +
        config[:filters].map { |f| f[:key_path].to_s } +
        config[:sorters].map { |s| s[:key_path].to_s }

      expected_key_chain = Dbee::KeyChain.new(key_paths)

      expect(subject.key_chain).to eq(expected_key_chain)
    end
  end

  context 'README examples' do
    EXAMPLES = {
      'Get all practices' => {
        fields: [
          { key_path: 'id' },
          { key_path: 'active' },
          { key_path: 'name' }
        ]
      },
      'Get all practices, limit to 10, and sort by name (descending) then id (ascending)' => {
        fields: [
          { key_path: 'id' },
          { key_path: 'active' },
          { key_path: 'name' }
        ],
        sorters: [
          { key_path: 'name', direction: :descending },
          { key_path: 'id' }
        ],
        limit: 10
      },
      "Get top 5 active practices and patient whose name start with 'Sm':" => {
        fields: [
          { key_path: 'name', display: 'Practice Name' },
          { key_path: 'patients.first', display: 'Patient First Name' },
          { key_path: 'patients.middle', display: 'Patient Middle Name' },
          { key_path: 'patients.last', display: 'Patient Last Name' }
        ],
        filters: [
          { type: :equals, key_path: 'active', value: true },
          { type: :starts_with, key_path: 'patients.last', value: 'Sm' }
        ],
        limit: 5
      },
      'Get practice IDs, patient IDs, names, and cell phone numbers that starts with 555' => {
        fields: [
          { key_path: 'id', display: 'Practice ID #' },
          { key_path: 'patients.id', display: 'Patient ID #' },
          { key_path: 'patients.first', display: 'Patient First Name' },
          { key_path: 'patients.middle', display: 'Patient Middle Name' },
          { key_path: 'patients.last', display: 'Patient Last Name' },
          { key_path: 'patients.cell_phone_numbers.phone_number', display: 'Patient Cell #' }
        ],
        filters: [
          { type: :equals, key_path: 'active', value: true },
          {
            type: :starts_with,
            key_path: 'patients.cell_phone_numbers.phone_number',
            value: '555'
          }
        ]
      }
    }.freeze

    EXAMPLES.each_pair do |name, query|
      specify name do
        expect(described_class.make(query)).to be_a(described_class)
      end
    end
  end
end
