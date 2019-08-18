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

    attr_reader :fields, :sorters, :limit, :filters

    def initialize(fields: [], sorters: [], limit: nil, filters: [])
      @fields   = Field.array(fields)
      @sorters  = Sorter.array(sorters)
      @limit    = limit.to_s.empty? ? nil : limit.to_i
      @filters  = Filters.array(filters)

      freeze
    end

    def ==(other)
      eql?(other)
    end

    def eql?(other)
      other.fields == fields &&
        other.sorters == sorters &&
        other.limit == limit &&
        other.filters == filters
    end
  end
end
