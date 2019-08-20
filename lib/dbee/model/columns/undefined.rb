# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  class Model
    class Columns
      # Any non-configured column will automatically be this type.
      # Also doubles as the base class for all columns specification subclasses.
      class Undefined
        acts_as_hashable

        attr_reader :name

        def initialize(name:)
          raise ArgumentError, 'name is required' if name.to_s.empty?

          @name = name.to_s
        end

        def coerce(value)
          value
        end

        def ==(other)
          other.name == name
        end
        alias eql? ==
      end
    end
  end
end
