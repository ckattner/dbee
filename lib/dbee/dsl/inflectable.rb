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

      def tableize(value)
        value.split('::')
             .last
             .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
             .gsub(/([a-z\d])([A-Z])/, '\1_\2')
             .tr('-', '_')
             .downcase
      end
    end
  end
end
