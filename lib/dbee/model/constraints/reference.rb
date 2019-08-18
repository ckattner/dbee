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
      # A Reference constraint is a constraint between two data models.  In DB terms:
      # the name represents the column name on the child and the parent represents the
      # column name on the parent table.
      class Reference < Base
        attr_reader :parent

        def initialize(name:, parent:)
          super(name: name)

          raise ArgumentError, 'parent is required' if parent.to_s.empty?

          @parent = parent.to_s

          freeze
        end

        def hash
          "#{super}#{parent}".hash
        end

        def ==(other)
          super && other.parent == parent
        end
        alias eql? ==
      end
    end
  end
end
