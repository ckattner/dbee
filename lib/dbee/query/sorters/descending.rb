# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'base'

module Dbee
  class Query
    class Sorters
      # Equivalent to: ORDER BY field DESC
      class Descending < Base; end
    end
  end
end
