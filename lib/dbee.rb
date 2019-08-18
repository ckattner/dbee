# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'acts_as_hashable'
require 'forwardable'

require_relative 'dbee/base'
require_relative 'dbee/model'
require_relative 'dbee/query'
require_relative 'dbee/providers'

# Top-level namespace that provides the main public API.
module Dbee
  class << self
    def sql(model, query, provider)
      model = model.is_a?(Hash) || model.is_a?(Model) ? Model.make(model) : model.to_model
      query = Query.make(query)

      provider.sql(model, query)
    end
  end
end
