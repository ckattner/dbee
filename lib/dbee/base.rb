# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require_relative 'dsl_schema_builder'
require_relative 'dsl/association_builder'
require_relative 'dsl/association'
require_relative 'dsl/methods'
require_relative 'dsl/reflectable'

module Dbee
  # Instead of using the configuration-first approach, you could use this super class for
  # Model declaration.
  class Base
    extend Dsl::Reflectable
    extend Dsl::Methods

    BASE_CLASS_CONSTANT = Dbee::Base

    class << self
      # Returns the smallest needed `Dbee::Schema` for the provided key_chain.
      def to_schema(key_chain)
        DslSchemaBuilder.new(self, key_chain).to_schema
      end

      # TODO: move these into a Compatibility module:
      # <b>DEPRECATED:</b> Please use <tt>to_schema</tt> instead.
      #
      # This method is cycle-resistant due to the fact that it is a requirement to send in a
      # key_chain.  That means each model produced using to_model is specific to a set of desired
      # fields.  Basically, you cannot derive a Model from a Base subclass without the context
      # of a Query.  This is not true for configuration-first Model definitions because, in that
      # case, cycles do not exist since the nature of the configuration is flat.
      def to_model(key_chain, name = nil, constraints = [], path_parts = [])
        warn '[DEPRECATION] `to_model` is deprecated.  Please use `to_schema` instead.'
        key = [key_chain, derived_name(name), constraints, path_parts]

        to_models[key] ||= Model.make(
          model_config(
            key_chain,
            derived_name(name),
            constraints,
            path_parts + [name]
          )
        )
      end

      def to_model_non_recursive(name = nil, constraints = [])
        Model.make(
          constraints: constraints,
          name: derived_name(name),
          partitioners: inherited_partitioners,
          table: inherited_table_name
        )
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

      def inflected_class_name
        inflector.underscore(inflector.demodulize(name))
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
        inherited_associations.select { |c| key_chain.ancestor_path?(path_parts, c.name) }
                              .map do |association|
          model_constant = association.model_constant

          model_constant.to_model(
            key_chain,
            association.name,
            association.constraints,
            path_parts
          )
        end
      end

      def to_models
        @to_models ||= {}
      end

      def inflected_table_name(name)
        inflector.pluralize(inflector.underscore(inflector.demodulize(name)))
      end

      def derived_name(name)
        name.to_s.empty? ? inflected_class_name : name.to_s
      end
    end
  end
end
