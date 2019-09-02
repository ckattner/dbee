# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  module Dsl
    # Provide methods for dealing with introspection of class hierarchies.
    module Reflectable
      # Start at child, end with parent
      def subclasses(base_class_constant)
        ancestors.select { |a| a < base_class_constant }
      end

      # Start at parent, end with child
      def reversed_subclasses(base_class_constant)
        subclasses(base_class_constant).reverse
      end
    end
  end
end
