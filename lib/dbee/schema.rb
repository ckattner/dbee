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
    attr_reader :models

    extend Forwardable
    def initialize(schema_config)
      init_models_by_name(schema_config)

      freeze
    end

    # Given a `Dbee::Model` and `Dbee::KeyPath`, this returns a list of
    # `Dbee::Relationship` and `Dbee::Model` pairs that lie on the key path.
    # The returned list will always have an even number of elements, always in
    # the form of relationship, model, relationship2, model2, etc. The
    # relationships and models correspond to each ancestor part of the key
    # path.
    #
    # The key_path argument can be either a `Dbee::KeyPath` or an array of
    # string ancestor names.
    #
    # An exception is raised of the provided key_path contains relationship
    # names that do not exist in this schema.
    def expand_query_path(model, key_path, query_path = [])
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
      models_by_name[model_name.to_s] || raise(Model::ModelNotFoundError, model_name)
    end

    def ==(other)
      other.instance_of?(self.class) && other.send(:models_by_name) == models_by_name
    end
    alias eql? ==

    private

    attr_reader :models_by_name

    def relationship_for_name!(model, rel_name)
      model.relationship_for_name(rel_name) ||
        raise("model '#{model.name}' does not have a '#{rel_name}' relationship")
    end

    def init_models_by_name(schema_config)
      @models_by_name = {}

      schema_config.each do |model_name, model_config|
        @models_by_name[model_name.to_s] = ensure_model_with_name(model_name, model_config)
      end
    end

    def ensure_model_with_name(model_name, model_config)
      if model_config.respond_to?(:name)
        raise ArgumentError, "Expected model name #{model_name}, got #{model_config.name}" \
          if model_name != model_config.name

        return model_config
      end
      Model.make((model_config || {}).merge('name' => model_name))
    end
  end
end
