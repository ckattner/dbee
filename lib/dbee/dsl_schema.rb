# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  # A schema represents an entire graph of related models from a DSL classes.
  class DslSchema
    acts_as_hashable

    attr_reader :models

    extend Forwardable
    def_delegators :graph, :write_to_graphic_file

    def initialize(models)
      @models = models || []
      @graph = RGL::AdjacencyGraph.new

      build_graph

      freeze
    end

    def neighbors?(model_a, model_b)
      graph.adjacent_vertices(model_a).any? { |neighbor| neighbor == model_b }
    end

    private

    attr_reader :graph

    # rubocop:disable Metrics/AbcSize
    # Ignoring AbcSize for now as this class is likely to end up on the cutting room floor.
    def build_graph
      models.each do |model|
        model_a = dbee_models_by_name[model.inflected_class_name] ||= model.to_model_non_recursive

        model.inherited_associations.each do |association|
          # puts "model: #{model}, der_name: #{model.inflected_class_name}, " \
          #      "assc. name: #{association.name}, assc class: #{association.model_constant}"
          model_b = dbee_models_by_name[association.name] ||= \
            dbee_model_from_association(association)
          graph.add_edge(model_a, model_b)
        end
      end
    end
    # rubocop:enable Metrics/AbcSize

    def dbee_models_by_name
      @dbee_models_by_name || {}
    end

    def dbee_model_from_association(association)
      association.model_constant.to_model_non_recursive(association.name)
    end
  end
end
