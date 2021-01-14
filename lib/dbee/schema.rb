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
    def expand_query_path(model, key_path, query_path = [])
      # accept both a Dbeee::KeyPath and an array
      ancestors = key_path.respond_to?(:ancestor_names) ? key_path.ancestor_names : key_path
      relationship_name = ancestors.first
      return query_path unless relationship_name

      relationship = relationship_for_name!(model, relationship_name)
      join_model = model_for_name!(relationship.model_name)
      expand_query_path(
        join_model,
        ancestors.drop(1),
        query_path + [relationship_for_name!(model, relationship_name), join_model]
      )
    end

    def model_for_name!(model_name)
      models_by_name[model_name] || raise(Model::ModelNotFoundError, model_name)
    end

    private

    attr_reader :graph, :models_by_name

    def expand_join_path(query_path, init_expanded_path)
      query_path.each_with_object(init_expanded_path) do |path_name, expanded_path|
        previous_path = expanded_path.keys.last
        previous_model = expanded_path[previous_path]
        relationship = relationship_for_name!(previous_model, path_name)

        model = model_for_name!(relationship.model_name)
        path = previous_path + [path_name]

        expanded_path[path] = model
      end
    end

    def relationship_for_name!(model, rel_name)
      model.relationship_for_name(rel_name) ||
        raise("model '#{model.name}' does not have a '#{rel_name}' relationship")
    end

    # TODO: split out aliases into their own nodes
    def build_graph
      models_by_name.each do |_name, model|
        model.relationships.each do |relationship|
          graph.add_edge(model, model_for_name!(relationship.model_name))
        end
      end
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
