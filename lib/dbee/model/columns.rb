# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'columns/boolean'
require_relative 'columns/undefined'

module Dbee
  class Model
    # Top-level class that allows for the making of columns.  For example, you can call this as:
    # - Columns.make(type: :boolean, name: :something)
    # - Columns.make(type: :undefined, name: :something_else)
    class Columns
      acts_as_hashable_factory

      register 'boolean',   Boolean
      register 'undefined', Undefined
    end
  end
end
