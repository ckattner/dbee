# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'key_path'

module Dbee
  class Query
    # Abstract representation of the ORDER BY part of a SQL statement.
    class Sorter
      acts_as_hashable

      module Direction
        ASCENDING = :ascending
        DESCENDING = :descending
      end
      include Direction

      attr_reader :key_path, :direction

      def initialize(key_path:, direction: ASCENDING)
        raise ArgumentError, 'key_path is required' if key_path.to_s.empty?

        @key_path = KeyPath.get(key_path)
        @direction = Direction.const_get(direction.to_s.upcase.to_sym)

        freeze
      end

      def ==(other)
        eql?(other)
      end

      def eql?(other)
        other.key_path == key_path && other.direction == direction
      end

      def descending?
        direction == DESCENDING
      end

      def ascending?
        !descending?
      end
    end
  end
end
