# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'model/constraints'
require_relative 'model/partitioner'
require_relative 'model/relationships'
require_relative 'util/make_keyed_by'

module Dbee
  # In DB terms, a Model is usually a table, but it does not have to be.  You can also re-model
  # your DB schema using Dbee::Models.
  class Model
    acts_as_hashable
    extend Dbee::Util::MakeKeyedBy
    extend Forwardable

    class ModelNotFoundError < StandardError; end

    attr_reader :constraints, :filters, :name, :partitioners, :relationships, :table

    def_delegator :models_by_name,  :values,  :models
    def_delegator :models,          :sort,    :sorted_models
    def_delegator :constraints,     :sort,    :sorted_constraints
    def_delegator :partitioners,    :sort,    :sorted_partitioners

    def initialize(
      name:,
      constraints: [], # Exists here for tree based model backward compatibility.
      relationships: [],
      models: [],      # Exists here for tree based model backward compatibility.
      partitioners: [],
      table: ''
    )
      @name           = name
      @constraints    = Constraints.array(constraints || []).uniq
      @relationships  = Relationships.make_keyed_by(:name, relationships)
      @models_by_name = name_hash(Model.array(models))
      @partitioners   = Partitioner.array(partitioners).uniq
      @table          = table.to_s.empty? ? @name : table.to_s

      ensure_input_is_valid

      freeze
    end

    def relationship_for_name(relationship_name)
      relationships[relationship_name]
    end

    def ==(other)
      other.instance_of?(self.class) &&
        other.name == name && other.table == table && children_are_equal(other)
    end
    alias eql? ==

    def <=>(other)
      name <=> other.name
    end

    def hash
      [
        name.hash,
        table.hash,
        relationships.hash,
        sorted_constraints.hash,
        sorted_partitioners.hash,
        sorted_models.hash
      ].hash
    end

    def to_s
      name
    end

    private

    attr_reader :models_by_name

    def name_hash(array)
      array.map { |a| [a.name, a] }.to_h
    end

    def children_are_equal(other)
      other.relationships == relationships &&
        other.sorted_constraints == sorted_constraints &&
        other.sorted_partitioners == sorted_partitioners &&
        other.sorted_models == sorted_models
    end

    def ensure_input_is_valid
      raise ArgumentError, 'name is required' if name.to_s.empty?

      constraints&.any? && relationships&.any? && \
        raise(ArgumentError, 'constraints and relationships are mutually exclusive')
    end
  end
end
