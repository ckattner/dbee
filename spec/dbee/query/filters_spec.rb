# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Dbee::Query::Filters do
  CONFIG = { key_path: 'a.b.c', value: :d }.freeze

  FACTORIES = {
    Dbee::Query::Filters::Contains => CONFIG.merge(type: :contains),
    Dbee::Query::Filters::Equals => CONFIG.merge(type: :equals),
    Dbee::Query::Filters::GreaterThanOrEqualTo => CONFIG.merge(type: :greater_than_or_equal_to),
    Dbee::Query::Filters::GreaterThan => CONFIG.merge(type: :greater_than),
    Dbee::Query::Filters::LessThanOrEqualTo => CONFIG.merge(type: :less_than_or_equal_to),
    Dbee::Query::Filters::LessThan => CONFIG.merge(type: :less_than),
    Dbee::Query::Filters::NotContain => CONFIG.merge(type: :not_contain),
    Dbee::Query::Filters::NotEquals => CONFIG.merge(type: :not_equals),
    Dbee::Query::Filters::NotStartWith => CONFIG.merge(type: :not_start_with),
    Dbee::Query::Filters::StartsWith => CONFIG.merge(type: :starts_with)
  }.freeze

  FACTORIES.each_pair do |constant, config|
    it "should instantiate #{constant} objects" do
      expect(described_class.make(config)).to be_a(constant)
    end
  end
end
