# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  class Query
    class Filters
      # Defines the shared implementation for all filters.
      class Base
        acts_as_hashable

        attr_reader :key_path

        def initialize(key_path:)
          raise ArgumentError, 'key_path is required' if key_path.to_s.empty?

          @key_path = KeyPath.get(key_path)
        end
      end
    end
  end
end
