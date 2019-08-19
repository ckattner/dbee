# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'

describe Dbee::Model::Constraints do
  CONFIG = { name: :a }.freeze

  FACTORIES = {
    Dbee::Model::Constraints::Reference => CONFIG.merge(parent: :b, type: :reference),
    Dbee::Model::Constraints::Static => CONFIG.merge(value: :b, type: :static)
  }.freeze

  FACTORIES.each_pair do |constant, config|
    it "should instantiate #{constant} objects" do
      expect(described_class.make(config)).to be_a(constant)
    end
  end
end
