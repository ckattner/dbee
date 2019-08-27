# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  class Query
    # This class is an abstraction of the SELECT part of a SQL statement.
    # The key_path is the relative path to the column while the display is the AS part of the
    # SQL SELECT statement.
    class Field
      acts_as_hashable

      attr_reader :key_path, :display

      def initialize(key_path:, display: nil)
        raise ArgumentError, 'key_path is required' if key_path.to_s.empty?

        @key_path = KeyPath.get(key_path)
        @display = (display.to_s.empty? ? key_path : display).to_s

        freeze
      end

      def hash
        "#{key_path}#{display}".hash
      end

      def ==(other)
        other.key_path == key_path && other.display == display
      end
      alias eql? ==

      def <=>(other)
        "#{key_path}#{display}" <=> "#{other.key_path}#{other.display}"
      end
    end
  end
end
