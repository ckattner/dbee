# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'query/field'
require_relative 'query/filters'
require_relative 'query/sorters'

module Dbee
  # This class is an abstration of a simplified SQL expression.  In DB terms:
  # - fields are the SELECT
  # - sorters are the ORDER BY
  # - limit is the TAKE
  # - filters are the WHERE
  class Query
    extend Forwardable
    acts_as_hashable

    attr_reader :fields,
                :filters,
                :from,
                :limit,
                :offset,
                :sorters

    def_delegator :fields,   :sort, :sorted_fields
    def_delegator :filters,  :sort, :sorted_filters
    def_delegator :sorters,  :sort, :sorted_sorters

    def initialize(
      fields: [],
      from: nil,
      filters: [],
      limit: nil,
      offset: nil,
      sorters: []
    )
      @fields  = Field.array(fields)
      @filters = Filters.array(filters).uniq
      @from    = from.to_s
      @limit   = limit.to_s.empty? ? nil : limit.to_i
      @offset  = offset.to_s.empty? ? nil : offset.to_i
      @sorters = Sorters.array(sorters).uniq

      freeze
    end

    def ==(other)
      other.instance_of?(self.class) &&
        other.limit == limit &&
        other.offset == offset &&
        other.from == from &&
        other.sorted_fields == sorted_fields &&
        other.sorted_filters == sorted_filters &&
        other.sorted_sorters == sorted_sorters
    end
    alias eql? ==

    def key_chain
      KeyChain.new(key_paths)
    end

    private

    def key_paths
      (
        fields.flat_map(&:key_paths) +
        filters.map(&:key_path) +
        sorters.map(&:key_path)
      )
    end
  end
end
