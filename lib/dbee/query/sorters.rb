# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'sorters/ascending'
require_relative 'sorters/descending'

module Dbee
  class Query
    # Top-level class that allows for the making of sorters.  For example, you can call this as:
    # - Sorters.make(key_path: 'id', direction: :ascending)
    # - Sorters.make(key_path: 'id')
    # - Sorters.make(key_path: 'id', direction: :descending)
    class Sorters
      acts_as_hashable_factory

      type_key 'direction'

      register '',            Ascending # Default if type is blank.
      register 'ascending',   Ascending
      register 'descending',  Descending
    end
  end
end
