# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'value_base'

module Dbee
  class Query
    class Filters
      # Equivalent to a SQL x LIKE 'value%' statement.
      class StartsWith < ValueBase; end
    end
  end
end
