# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'constraints/reference'
require_relative 'constraints/static'

module Dbee
  class Model
    # Top-level class that allows for the making of constraints.  For example,
    # you can call this as:
    # - Constraints.make(type: :reference, name: :id, parent: some_id)
    # - Constraints.make(type: :static, name: :genre, value: :comedy)
    class Constraints
      acts_as_hashable_factory

      register 'reference', Reference
      register 'static',    Static
    end
  end
end
