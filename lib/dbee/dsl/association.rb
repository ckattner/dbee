# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  module Dsl
    # The main logic that can take input from model association declaration and turn it into
    # usable information.
    class Association
      attr_reader :on_class_name, :inflector, :name, :opts

      def initialize(on_class_name, inflector, name, opts = {})
        raise ArgumentError, 'on_class_name is required'  if on_class_name.to_s.empty?
        raise ArgumentError, 'inflector is required'      unless inflector
        raise ArgumentError, 'name is required'           if name.to_s.empty?

        @on_class_name  = on_class_name
        @inflector      = inflector
        @name           = name.to_s
        @opts           = opts || {}

        freeze
      end

      def model_constant
        constantize(class_name)
      end

      def constraints
        opts[:constraints] || []
      end

      private

      def class_name
        opts[:model] || relative_class_name
      end

      # This will automatically prefix the name of the module within the current classes
      # hierarchy.  If the class does not happen to be in the same namespace then it needs
      # to be explicitly set in the association using 'model' option.
      def relative_class_name
        (on_class_name.split('::')[0...-1] + [inflector.classify(name)]).join('::')
      end

      # Only use Module constant resolution if a string or symbol was passed in.
      # Any other type is defined as an acceptable constant and is simply returned.
      def constantize(value)
        value.is_a?(String) || value.is_a?(Symbol) ? object_constant(value) : value
      end

      # If the constant has been loaded, we can safely use it through const_get.
      # If the constant has not been loaded, we need to defer to const_missing to resolve it.
      # If we blindly call const_get, it may return false positives for namespaced constants
      # or anything nested.
      def object_constant(value)
        Object.const_defined?(value) ? Object.const_get(value) : Object.const_missing(value)
      end
    end
  end
end
