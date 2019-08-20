# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'model/columns'
require_relative 'model/constraints'

module Dbee
  # In DB terms, a Model is usually a table, but it does not have to be.  You can also re-model
  # your DB schema using Dbee::Models.
  class Model
    acts_as_hashable

    JOIN_CHAR = '.'

    class ModelNotFound < StandardError; end

    attr_reader :constraints, :name

    def initialize(name:, columns: [], constraints: [], models: [], table: '')
      raise ArgumentError, 'name is required' if name.to_s.empty?

      @name             = name.to_s
      @columns_by_name  = name_hash(Columns.array(columns))
      @constraints      = Constraints.array(constraints)
      @models_by_name   = name_hash(Model.array(models))
      @table            = table.to_s

      freeze
    end

    def name_hash(array)
      array.map { |a| [a.name, a] }.to_h
    end

    def table
      @table.to_s.empty? ? name : @table
    end

    def models
      models_by_name.values
    end

    def columns
      columns_by_name.values
    end

    def column(name)
      columns_by_name[name.to_s] || Columns::Undefined.new(name: name)
    end

    def ancestors(parts = [], alias_chain = [], found = {})
      return found if Array(parts).empty?

      alias_chain = [] if Array(alias_chain).empty?

      model_name = parts.first

      model = models_by_name[model_name.to_s]

      raise ModelNotFound, "Cannot traverse: #{model_name}" unless model

      new_alias_chain = alias_chain + [model_name]

      new_alias = new_alias_chain.join(JOIN_CHAR)

      found[new_alias] = model

      model.ancestors(parts[1..-1], new_alias_chain, found)
    end

    def ==(other)
      other.name == name &&
        other.table == table &&
        other.models == models &&
        other.constraints == constraints &&
        other.columns == columns
    end
    alias eql? ==

    private

    attr_reader :models_by_name, :columns_by_name
  end
end
