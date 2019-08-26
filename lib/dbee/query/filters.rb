# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'filters/contains'
require_relative 'filters/equals'
require_relative 'filters/greater_than_or_equal_to'
require_relative 'filters/greater_than'
require_relative 'filters/less_than_or_equal_to'
require_relative 'filters/less_than'
require_relative 'filters/not_contain'
require_relative 'filters/not_equals'
require_relative 'filters/not_start_with'
require_relative 'filters/starts_with'

module Dbee
  class Query
    # Top-level class that allows for the making of filters.  For example, you can call this as:
    # - Filters.make(type: :contains, value: 'something')
    class Filters
      acts_as_hashable_factory

      register '',                          Equals # Default if type is blank.
      register 'contains',                  Contains
      register 'equals',                    Equals
      register 'greater_than_or_equal_to',  GreaterThanOrEqualTo
      register 'greater_than',              GreaterThan
      register 'less_than_or_equal_to',     LessThanOrEqualTo
      register 'less_than',                 LessThan
      register 'not_contain',               NotContain
      register 'not_equals',                NotEquals
      register 'not_start_with',            NotStartWith
      register 'starts_with',               StartsWith
    end
  end
end
