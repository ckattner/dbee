# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  class Query
    # This class represents a relative path from a model to a column.  For example:
    # Say we have a model called "users" which is represented by a "users" table.
    # The "users" table also has a one-to-many relationship with a "phone_numbers" table, which
    # is modeled as a nested model under "users" as "phone_numbers".  Then, to get the column:
    # "area_code", you would use: "phone_numbers.area_code".
    # Say the column "name" is located on "users", you could use the key path: "name".
    # This also works for deeper nested columns in the same fashion.
    class KeyPath
      extend Forwardable

      class << self
        def get(obj)
          obj.is_a?(self.class) ? obj : new(obj)
        end
      end

      SPLIT_CHAR = '.'

      private_constant :SPLIT_CHAR

      attr_reader :value, :ancestor_names, :column_name

      def_delegators :value, :to_s

      def initialize(value)
        raise 'Value is required' if value.to_s.empty?

        @value          = value.to_s
        @ancestor_names = value.to_s.split(SPLIT_CHAR)
        @column_name    = @ancestor_names.pop

        freeze
      end

      def hash
        value.hash
      end

      def ==(other)
        other.to_s == to_s
      end
      alias eql? ==
    end
  end
end
