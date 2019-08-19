# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'query/field'
require_relative 'query/filters'
require_relative 'query/sorter'

module Dbee
  # This class is an abstration of a simplified SQL expression.  In DB terms:
  # - fields are the SELECT
  # - sorters are the ORDER BY
  # - limit is the TAKE
  # - filters are the WHERE
  class Query
    acts_as_hashable

    attr_reader :fields, :filters, :limit, :sorters

    def initialize(fields: [], filters: [], limit: nil, sorters: [])
      @fields   = Field.array(fields)
      @filters  = Filters.array(filters)
      @limit    = limit.to_s.empty? ? nil : limit.to_i
      @sorters  = Sorter.array(sorters)

      freeze
    end

    def ==(other)
      eql?(other)
    end

    def eql?(other)
      other.fields == fields &&
        other.filters == filters &&
        other.limit == limit &&
        other.sorters == sorters
    end
  end
end
