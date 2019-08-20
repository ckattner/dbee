# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'undefined'

module Dbee
  class Model
    class Columns
      # Describes a boolean column.  The main value here is the value is pretty pliable.
      # For example: the value 'y' or '1' will be coerced to true.
      class Boolean < Undefined
        attr_reader :nullable

        alias nullable? nullable

        def initialize(name:, nullable: true)
          super(name: name)

          @nullable = nullable

          freeze
        end

        def ==(other)
          super && other.nullable == nullable
        end
        alias eql? ==

        def coerce(value)
          if nullable? && nully?(value)
            nil
          elsif truthy?(value)
            true
          else
            false
          end
        end

        private

        def null_or_empty?(val)
          val.nil? || val.to_s.empty?
        end

        # rubocop:disable Style/DoubleNegation
        def nully?(val)
          null_or_empty?(val) || !!(val.to_s =~ /(nil|null)$/i)
        end

        def truthy?(val)
          !!(val.to_s =~ /(true|t|yes|y|1)$/i)
        end
        # rubocop:enable Style/DoubleNegation
      end
    end
  end
end
