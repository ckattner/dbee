# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  # Instead of using the configuration-first approach, you could use this super class for
  # Model declaration.
  class Base
    class << self
      def table(name)
        @table_name = name.to_s

        self
      end

      def association(name, opts = {})
        associations_by_name[name.to_s] = opts.merge(name: name)

        self
      end

      # This method is cycle-resistant due to the fact that it is a requirement to send in a
      # key_chain.  That means each model produced using to_model is specific to a set of desired
      # fields.  Basically, you cannot derive a Model from a Base subclass without the context
      # of a Query.  This is not true for configuration-first Model definitions because, in that
      # case, cycles do not exist since the nature of the configuration is flat.
      def to_model(key_chain, name = nil, constraints = [], path_parts = [])
        derived_name  = derive_name(name)
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

      def table_name?
        !table_name.empty?
      end

      def inherited_table_name
        subclasses.find(&:table_name?)&.table_name || ''
      end

      def inherited_associations_by_name
        reversed_subclasses.each_with_object({}) do |subclass, memo|
          memo.merge!(subclass.associations_by_name)
        end
      end

      private

      def subclasses
        ancestors.select { |a| a < Dbee::Base }
      end

      def reversed_subclasses
        subclasses.reverse
      end

      def model_config(key_chain, name, constraints, path_parts)
        {
          constraints: constraints,
          models: associations(key_chain, path_parts),
          name: name,
          table: derive_table
        }
      end

      def derive_name(name)
        name.to_s.empty? ? inflected_name : name.to_s
      end

      def derive_table
        inherited_table = inherited_table_name

        inherited_table.empty? ? inflected_name : inherited_table
      end

      def associations(key_chain, path_parts)
        inherited_associations_by_name.values
                                      .select { |c| key_chain.ancestor_path?(path_parts, c[:name]) }
                                      .each_with_object([]) do |config, memo|
          model_constant          = constantize(config[:model])
          associated_constraints  = config[:constraints]
          name                    = config[:name]

          memo << model_constant.to_model(key_chain, name, associated_constraints, path_parts)
        end
      end

      def to_models
        @to_models ||= {}
      end

      def inflected_name
        name.split('::')
            .last
            .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .tr('-', '_')
            .downcase
      end

      def constantize(value)
        value.is_a?(String) || value.is_a?(Symbol) ? Object.const_get(value) : value
      end
    end
  end
end
