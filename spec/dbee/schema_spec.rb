# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

require 'spec_helper'
require_relative '../fixtures/models'

describe Dbee::Schema do
  it 'knows if two models are related' do
    model_name = 'Theaters, Members, and Movies Directed Graph Based with Nested Sub-models'
    schema_config = yaml_fixture('models.yaml')[model_name]
    theaters_model = Dbee::Model.make(schema_config['theaters'].merge('name' => 'theaters'))
    members_model = Dbee::Model.make(schema_config['members'].merge('name' => 'members'))
    demographics_model = Dbee::Model.make(
      schema_config['demographics'].merge('name' => 'demographics')
    )

    subject = described_class.new(schema_config)
    # subject.write_to_graphic_file
    expect(subject.neighbors?(theaters_model, members_model)).to be(true)
    expect(subject.neighbors?(members_model, demographics_model)).to be(true)

    # Theaters and demographics related through members and are not direct neighbors.
    expect(subject.neighbors?(theaters_model, demographics_model)).to be(false)
  end
end
