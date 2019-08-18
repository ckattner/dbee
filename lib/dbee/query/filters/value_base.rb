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
    class Filters
      # Defines all shared implementation for filter operators that focus on a singular value.
      class ValueBase < Base
        attr_reader :value

        def initialize(key_path:, value: nil)
          super(key_path: key_path)

          @value = value

          freeze
        end
      end
    end
  end
end
