# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

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

      attr_reader :direction, :key_path

      def initialize(key_path:, direction: ASCENDING)
        raise ArgumentError, 'key_path is required' if key_path.to_s.empty?

        @direction  = Direction.const_get(direction.to_s.upcase.to_sym)
        @key_path   = KeyPath.get(key_path)

        freeze
      end

      def descending?
        direction == DESCENDING
      end

      def ascending?
        !descending?
      end

      def hash
        "#{key_path}#{direction}".hash
      end

      def ==(other)
        other.instance_of?(self.class) &&
          other.key_path == key_path &&
          other.direction == direction
      end
      alias eql? ==

      def <=>(other)
        "#{key_path}#{direction}" <=> "#{other.key_path}#{other.direction}"
      end
    end
  end
end
