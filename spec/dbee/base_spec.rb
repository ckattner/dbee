# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'
require 'fixtures/models'

describe Dbee::Base do
  it 'compiles to Model instance correctly' do
    model_name      = 'Theaters, Members, and Movies'
    expected_config = yaml_fixture('models.yaml')[model_name]

    expected_model = Dbee::Model.make(expected_config)

    expect(Models::Theaters.to_model).to eq(expected_model)
  end

  context 'inheritance' do
    specify 'table is honored if set on subclass' do
      expect(Models::A.inherited_table_name).to eq('table_set_to_a')
      expect(Models::B.inherited_table_name).to eq('table_set_to_b')
    end

    specify 'table is honored if set on parent' do
      expect(Models::C.inherited_table_name).to eq('table_set_to_a')
      expect(Models::D.inherited_table_name).to eq('table_set_to_a')
      expect(Models::E.inherited_table_name).to eq('table_set_to_e')
    end
  end
end
