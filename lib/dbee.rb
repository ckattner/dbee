# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'acts_as_hashable'
require 'dry/inflector'
require 'forwardable'
require 'rgl/adjacency'
require 'rgl/dot'

require_relative 'dbee/base'
require_relative 'dbee/constant_resolver'
require_relative 'dbee/dsl_schema'
require_relative 'dbee/key_chain'
require_relative 'dbee/key_path'
require_relative 'dbee/model'
require_relative 'dbee/providers'
require_relative 'dbee/query'
require_relative 'dbee/schema'
require_relative 'dbee/schema_from_tree_based_model'

# Top-level namespace that provides the main public API.
module Dbee
  class << self
    # Use this to override the built in Dry::Inflector instance.
    # This is useful is you have your own grammar/overrides you need to load.
    # See the referenced gem here: https://github.com/dry-rb/dry-inflector
    attr_writer :inflector

    def inflector
      @inflector ||= Dry::Inflector.new
    end

    def sql(schema_hash_or_model, query, provider)
      query = Query.make(query)
      provider.sql(make_schema(schema_hash_or_model, query.key_chain), query)
    end

    private

    def make_schema(input, _key_chain)
      return input if input.is_a?(Dbee::Schema)

      model_or_schema = to_object(input)
      if model_or_schema.is_a?(Model)
        SchemaFromTreeBasedModel.convert(model_or_schema)
      else
        model_or_schema
      end
    end

    def to_object(input)
      return input unless input.is_a?(Hash)

      if input.key?(:models) && input[:models].is_a?(Array)
        # This is a tree based model:
        Model.make(input)
      else
        Schema.new(input)
      end
    end
  end
end
