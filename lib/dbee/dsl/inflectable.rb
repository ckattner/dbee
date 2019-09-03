# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  module Dsl
    # Provides methods for dealing with naming grammar.
    module Inflectable
      def constantize(value)
        value.is_a?(String) || value.is_a?(Symbol) ? Object.const_get(value) : value
      end

      def inflected_table_name(name)
        inflector.pluralize(inflector.underscore(inflector.demodulize(name)))
      end

      def inflected_class_name(name)
        inflector.underscore(inflector.demodulize(name))
      end

      def inflector
        @inflector ||= Dry::Inflector.new
      end
    end
  end
end
