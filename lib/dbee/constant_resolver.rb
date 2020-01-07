# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  # This class is responsible for turning strings and symbols into constants.
  # It does not deal with inflection, simply just constant resolution.
  class ConstantResolver
    # Only use Module constant resolution if a string or symbol was passed in.
    # Any other type is defined as an acceptable constant and is simply returned.
    def constantize(value)
      value.is_a?(String) || value.is_a?(Symbol) ? object_constant(value) : value
    end

    private

    # If the constant has been loaded, we can safely use it through const_get.
    # If the constant has not been loaded, we need to defer to const_missing to resolve it.
    # If we blindly call const_get, it may return false positives for namespaced constants
    # or anything nested.
    def object_constant(value)
      if Object.const_defined?(value, false)
        Object.const_get(value, false)
      else
        Object.const_missing(value)
      end
    end
  end
end
