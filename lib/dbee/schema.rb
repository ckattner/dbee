# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  # A schema represents an entire graph of related models.
  class Schema
    acts_as_hashable

    attr_reader :models

    extend Forwardable
    def_delegators :graph, :write_to_graphic_file

    def initialize(schema_config)
      init_models_by_name(schema_config)

      @graph = RGL::DirectedAdjacencyGraph.new
      build_graph

      freeze
    end

    def neighbors?(model_a, model_b)
      graph.adjacent_vertices(model_a).any? { |neighbor| neighbor == model_b }
    end

    # TODO: document me!
    def expand_query_path(query_path)
      query_path.each_with_object({}) do |path_name, expanded_path|
        model = models_by_name[path_name] || raise(Dbee::Model::ModelNotFoundError, path_name)

        previous_path = expanded_path.keys&.last || []
        previous_model = expanded_path[previous_path]
        path = previous_path + [path_name]

        previous_model && !neighbors?(previous_model, model) && \
          raise(Dbee::Model::ModelNotFoundError,
                "no path exists from #{previous_path.last} to #{path_name}")

        expanded_path[path] = model
      end
    end

    private

    attr_reader :graph, :models_by_name

    def build_graph
      models_by_name.each do |_name, model|
        model.relationships.each do |relationship|
          model_name = relationship.model || relationship.name
          model_b = models_by_name[model_name] || raise("no model found named: #{model_name}")
          graph.add_edge(model, model_b)
        end
      end
    end

    def dbee_model_from_association(association)
      association.model_constant.to_model_non_recursive(association.name)
    end

    def init_models_by_name(schema_config)
      @models_by_name = {}

      schema_config.each do |model_name, model_config|
        args = (model_config || {}).merge('name' => model_name)
        @models_by_name[model_name] = Model.make(args)
      end
    end
  end
end
