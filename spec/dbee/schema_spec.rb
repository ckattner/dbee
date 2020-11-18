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
    dbee_model_theater = Models::Theater.to_model_non_recursive
    dbee_model_members = Models::Member.to_model_non_recursive(:members)
    # There is confusion about the singular class name and the plural relationship name.
    dbee_model_member = Models::Member.to_model_non_recursive(:member)

    dbee_model_demographic = Models::Demographic.to_model_non_recursive(:demos)

    subject = described_class.new([Models::Theater, Models::Member, Models::Demographic])
    expect(subject.neighbors?(dbee_model_theater, dbee_model_members)).to be(true)
    expect(subject.neighbors?(dbee_model_member, dbee_model_demographic)).to be(true)

    # Theaters and demographics related through members and are not direct neighbors.
    expect(subject.neighbors?(dbee_model_theater, dbee_model_demographic)).to be(false)

    # puts "file name: #{subject.write_to_graphic_file}"
  end
end
