# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  # Backward compatibility layer for tree based models and queries. Accepts
  # both the new graph based schemas and the old tree based models and ensures
  # that a valid schema and corresponding query are returned.
  class SchemaCompatibility # :nodoc:
    attr_reader :schema

    def initialize(schema_or_model, query)
      @orig_query = Query.make(query)
      @schema = make_schema(schema_or_model)

      freeze
    end

    def query
      return orig_query unless from_model

      Query.new(
        from: from_model,
        fields: orig_query.fields,
        filters: orig_query.filters,
        sorters: orig_query.sorters,
        limit: orig_query.limit
      )
    end

    private

    attr_reader :orig_query, :from_model

    def make_schema(input)
      return input if input.is_a?(Dbee::Schema)

      model_or_schema = to_object(input)
      if model_or_schema.is_a?(Model)
        @from_model = model_or_schema.name
        SchemaFromTreeBasedModel.convert(model_or_schema)
      else
        model_or_schema
      end
    end

    def to_object(input)
      return input.to_schema(orig_query.key_chain) if input.respond_to?(:to_schema)
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
