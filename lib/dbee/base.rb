# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'dsl/inflectable'
require_relative 'dsl/reflectable'

module Dbee
  # Instead of using the configuration-first approach, you could use this super class for
  # Model declaration.
  class Base
    extend Dsl::Inflectable
    extend Dsl::Reflectable

    BASE_CLASS_CONSTANT = Dbee::Base

    class << self
      def partitioner(name, value)
        partitioners << { name: name, value: value }
      end

      def table(name)
        tap { @table_name = name.to_s }
      end

      def parent(name, opts = {})
        primary_key = opts[:primary_key] || inflector.foreign_key(name)
        foreign_key = opts[:foreign_key] || :id

        reference_constraint = {
          name: foreign_key,
          parent: primary_key
        }

        association_opts = {
          model: opts[:model],
          constraints: [reference_constraint] + make_constraints(opts)
        }

        association(name, association_opts)
      end

      def children(name, opts = {})
        primary_key = opts[:primary_key] || :id
        foreign_key = opts[:foreign_key] || inflector.foreign_key(self.name)

        reference_constraint = {
          name: foreign_key,
          parent: primary_key
        }

        association_opts = {
          model: opts[:model],
          constraints: [reference_constraint] + make_constraints(opts)
        }

        association(name, association_opts)
      end

      def association(name, opts = {})
        tap { associations_by_name[name.to_s] = opts.merge(name: name) }
      end

      # This method is cycle-resistant due to the fact that it is a requirement to send in a
      # key_chain.  That means each model produced using to_model is specific to a set of desired
      # fields.  Basically, you cannot derive a Model from a Base subclass without the context
      # of a Query.  This is not true for configuration-first Model definitions because, in that
      # case, cycles do not exist since the nature of the configuration is flat.
      def to_model(key_chain, name = nil, constraints = [], path_parts = [])
        derived_name  = name.to_s.empty? ? inflected_class_name(self.name) : name.to_s
        key           = [key_chain, derived_name, constraints, path_parts]

        to_models[key] ||= Model.make(
          model_config(
            key_chain,
            derived_name,
            constraints,
            path_parts + [name]
          )
        )
      end

      def table_name
        @table_name || ''
      end

      def associations_by_name
        @associations_by_name ||= {}
      end

      def partitioners
        @partitioners ||= []
      end

      def table_name?
        !table_name.empty?
      end

      def inherited_table_name
        subclasses(BASE_CLASS_CONSTANT).find(&:table_name?)&.table_name ||
          inflected_table_name(reversed_subclasses(BASE_CLASS_CONSTANT).first.name)
      end

      def inherited_associations
        reversed_subclasses(BASE_CLASS_CONSTANT).each_with_object({}) do |subclass, memo|
          memo.merge!(subclass.associations_by_name)
        end.values
      end

      def inherited_partitioners
        reversed_subclasses(BASE_CLASS_CONSTANT).inject([]) do |memo, subclass|
          memo + subclass.partitioners
        end
      end

      private

      def model_config(key_chain, name, constraints, path_parts)
        {
          constraints: constraints,
          models: associations(key_chain, path_parts),
          name: name,
          partitioners: inherited_partitioners,
          table: inherited_table_name
        }
      end

      def associations(key_chain, path_parts)
        inherited_associations.select { |c| key_chain.ancestor_path?(path_parts, c[:name]) }
                              .each_with_object([]) do |config, memo|
          class_name              = config[:model] || relative_class_name(config[:name])
          model_constant          = constantize(class_name)
          associated_constraints  = config[:constraints]
          name                    = config[:name]

          memo << model_constant.to_model(
            key_chain,
            name,
            associated_constraints,
            path_parts
          )
        end
      end

      def to_models
        @to_models ||= {}
      end

      def relative_class_name(name)
        (self.name.split('::')[0...-1] + [inflector.classify(name)]).join('::')
      end

      def array(value)
        value.is_a?(Hash) ? [value] : Array(value)
      end

      def make_constraints(opts = {})
        array(opts[:constraints]) + array(opts[:static]).map { |c| c.merge(type: :static) }
      end
    end
  end
end
