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

      def to_model(name = nil, constraints = [], from = nil)
        name  = derive_name(name)
        key   = [name, constraints, from]

        to_models[key] ||= Model.make(model_config(name, constraints, from))
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

      def model_config(name, constraints, from)
        {
          constraints: constraints,
          models: associations(from),
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

      def associations(from)
        inherited_associations_by_name.values
                                      .reject { |c| c[:name].to_s == from.to_s }
                                      .each_with_object([]) do |config, memo|
          model_klass             = config[:model]
          associated_constraints  = config[:constraints]
          name                    = config[:name]

          memo << model_klass.to_model(name, associated_constraints, name)
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
    end
  end
end
