# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'base'

module Dbee
  class Model
    class Constraints
      # A static constraint is a equality constraint on a child and/or parent column to a
      # static value. It is usually used in conjunction with a ReferenceConstraint,
      # further giving it more scoping.
      class Static < Base
        attr_reader :value

        def initialize(name: '', parent: '', value: nil)
          if name.to_s.empty? && parent.to_s.empty?
            raise ArgumentError, "name (#{name}) and/or parent (#{parent}) required"
          end

          super(name: name, parent: parent)

          @value = value

          freeze
        end

        def hash
          "#{super}#{value}".hash
        end

        def ==(other)
          super && other.value == value
        end
        alias eql? ==
      end
    end
  end
end
