# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  class Model
    # An Partitioner is a way to explicitly define constraints on a model.  For example, say we
    # want to create a data model, but restrict the returned data to a subset based on a 'type'
    # column like ActiveRecord does for Single Table Inheritance. We could use a partition
    # to define this constraint.
    class Partitioner
      acts_as_hashable

      attr_reader :name, :value

      def initialize(name: '', value: nil)
        raise ArgumentError, 'name is required' if name.to_s.empty?

        @name   = name.to_s
        @value  = value
      end

      def <=>(other)
        "#{name}#{value}" <=> "#{other.name}#{other.value}"
      end

      def hash
        "#{name}#{value}".hash
      end

      def ==(other)
        other.instance_of?(self.class) &&
          other.name == name &&
          other.value == value
      end
      alias eql? ==
    end
  end
end
