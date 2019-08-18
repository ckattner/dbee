# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  module Providers
    # Default stand-in provider that ships with Dbee.  The main use-case would be to plug in a
    # provider or provide your own implementation.  There really is no real-world use
    # of this provider.
    class NullProvider
      def sql(_model, _query)
        'SELECT NULL'
      end
    end
  end
end
