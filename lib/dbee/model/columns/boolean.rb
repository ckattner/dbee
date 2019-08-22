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
      # Describes a boolean column that can accept a wide range of values and still resolves to
      # a boolean, such as: true, t, yes, y, 1, false, f, n, 0, nil, null.
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

        def nully?(val)
          null_or_empty?(val) || val.to_s.match?(/\A(nil|null)$\z/i)
        end

        def truthy?(val)
          val.to_s.match?(/\A(true|t|yes|y|1)$\z/i)
        end
      end
    end
  end
end
