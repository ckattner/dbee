# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  # This creates a Dbee::Schema from a variety of different inputs:
  #
  # 1. The hash representation of a schema.
  # 2. A Dbee::Base subclass (code based models).
  #
  # For backward compatibility, tree based models are also supported in the
  # following formats:
  #
  # 3. The hash representation of a tree based model.
  # 4. Dbee::Model instances in tree based form (using the deprecated constraints and models
  #    attributes).
  class SchemaCreator # :nodoc:
    attr_reader :schema

    def initialize(schema_or_model, query)
      @orig_query = Query.make(query)
      @schema = make_schema(schema_or_model)

      freeze
    end

    # Returns a Dbee::Query instance with a "from" attribute which is
    # sometimes derived for tree based models.
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
      return input.to_schema(orig_query.key_chain) if input.respond_to?(:to_schema)

      model_or_schema = to_object(input)
      if model_or_schema.is_a?(Model)
        @from_model = model_or_schema.name
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
