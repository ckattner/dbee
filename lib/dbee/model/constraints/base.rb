# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  class Model
    class Constraints
      # Base class for all constraints.
      class Base
        acts_as_hashable

        attr_reader :name

        def initialize(name:)
          raise ArgumentError, 'name is required' if name.to_s.empty?

          @name = name.to_s
        end

        def hash
          name.hash
        end

        def ==(other)
          other.name == name
        end
        alias eql? ==
      end
    end
  end
end
