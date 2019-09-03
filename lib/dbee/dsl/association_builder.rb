# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Dbee
  module Dsl
    # This is really syntactic sugar built on top of Association.  It can handle two main
    # use-cases when declaring associations:
    # - parent: create an association to a parent model (foreign key is on immediate table)
    # - child: create an association to a child model (foreign key is on child table)
    class AssociationBuilder
      attr_reader :inflector

      def initialize(inflector)
        raise ArgumentError, 'inflector is required' unless inflector

        @inflector = inflector

        freeze
      end

      def parent_association(on_class_name, name, opts = {})
        primary_key = opts[:primary_key] || inflector.foreign_key(name)
        foreign_key = opts[:foreign_key] || :id

        association(on_class_name, name, opts, primary_key, foreign_key)
      end

      def child_association(on_class_name, name, opts = {})
        primary_key = opts[:primary_key] || :id
        foreign_key = opts[:foreign_key] || inflector.foreign_key(on_class_name)

        association(on_class_name, name, opts, primary_key, foreign_key)
      end

      private

      def association(on_class_name, name, opts, primary_key, foreign_key)
        reference_constraint = {
          name: foreign_key,
          parent: primary_key
        }

        association_opts = {
          model: opts[:model],
          constraints: [reference_constraint] + make_constraints(opts)
        }

        Association.new(on_class_name, inflector, name, association_opts)
      end

      def make_constraints(opts = {})
        array(opts[:constraints]) + array(opts[:static]).map { |c| c.merge(type: :static) }
      end

      def array(value)
        value.is_a?(Hash) ? [value] : Array(value)
      end
    end
  end
end
