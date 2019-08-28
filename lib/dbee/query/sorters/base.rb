# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  class Query
    class Sorters
      # Abstract representation of the ORDER BY part of a SQL statement.
      class Base
        acts_as_hashable

        attr_reader :key_path

        def initialize(key_path:)
          raise ArgumentError, 'key_path is required' if key_path.to_s.empty?

          @key_path = KeyPath.get(key_path)

          freeze
        end

        def hash
          "#{self.class.name}#{key_path}".hash
        end

        def ==(other)
          other.instance_of?(self.class) &&
            other.key_path == key_path
        end
        alias eql? ==

        def <=>(other)
          "#{key_path}#{self.class.name}" <=> "#{other.key_path}#{other.class.name}"
        end
      end
    end
  end
end
