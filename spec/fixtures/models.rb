# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Models
  class Movie < Dbee::Base; end

  class PhoneNumber < Dbee::Base; end

  class Demographic < Dbee::Base
    association :phone_numbers, model: 'Models::PhoneNumber',
                                constraints: {
                                  name: :demographic_id,
                                  parent: :id
                                }
  end

  class MemberBase < Dbee::Base
    association :demos, model: Demographic,
                        constraints: { type: :reference, name: :member_id, parent: :id }

    association :movies, model: Movie,
                         constraints: { name: :member_id, parent: :id }
  end

  class Member < MemberBase
    table 'members'

    association :favorite_comic_movies, model: Movie, constraints: [
      { type: :reference, name: :member_id, parent: :id },
      { type: :static, name: :genre, value: 'comic' }
    ]

    association :favorite_mystery_movies, model: Movie, constraints: [
      { type: :reference, name: :member_id, parent: :id },
      { type: :static, name: :genre, value: 'mystery' }
    ]

    association :favorite_comedy_movies, model: Movie, constraints: [
      { type: :reference, name: :member_id, parent: :id },
      { type: :static, name: :genre, value: 'comedy' }
    ]
  end

  class TheaterBase < Dbee::Base
    association :members, model: Member, constraints: [
      { type: :reference, name: :tid, parent: :id },
      { type: :reference, name: :partition, parent: :partition }
    ]
  end

  class Theater < TheaterBase
    table 'theaters'

    association :parent_theater, model: self, constraints: [
      { type: :reference, name: :id, parent: :parent_theater_id }
    ]
  end

  class A < Dbee::Base
    table 'table_set_to_a'
  end

  class B < A
    table 'table_set_to_b'
  end

  class C < A; end

  class D < A
    table ''
  end

  class E < B
    table 'table_set_to_e'
  end
end

module ReadmeDataModels
  class PhoneNumber < Dbee::Base
    table :phones
  end

  class Note < Dbee::Base; end

  class Patient < Dbee::Base
    association :notes, model: Note, constraints: {
      type: :reference, name: :patient_id, parent: :id
    }

    association :work_phone_number, model: PhoneNumber, constraints: [
      { type: :reference, name: :patient_id, parent: :id },
      { type: :static, name: :phone_number_type, value: 'work' }
    ]

    association :cell_phone_number, model: PhoneNumber, constraints: [
      { type: :reference, name: :patient_id, parent: :id },
      { type: :static, name: :phone_number_type, value: 'cell' }
    ]

    association :fax_phone_number, model: PhoneNumber, constraints: [
      { type: :reference, name: :patient_id, parent: :id },
      { type: :static, name: :phone_number_type, value: 'fax' }
    ]
  end

  class Practice < Dbee::Base
    association :patients, model: Patient, constraints: {
      type: :reference, name: :practice_id, parent: :id
    }
  end
end

module Cycles
  class BaseA < Dbee::Base
    association :b1, model: 'Cycles::B'
  end

  class A < BaseA
    table :as

    association :b2, model: 'Cycles::B'
  end

  class B < Dbee::Base
    association :c, model: 'Cycles::C'

    association :d, model: 'Cycles::D'
  end

  class C < Dbee::Base
    association :a, model: 'Cycles::A'
  end

  class D < Dbee::Base
    association :a, model: 'Cycles::A'
  end
end

# Examples of Rails Single Table Inheritance.
module PartitionerExamples
  class Owner < Dbee::Base
    association :dogs, model: 'PartitionerExamples::Dog', constraints: {
      name: :owner_id, parent: :id
    }
  end

  class Animal < Dbee::Base; end

  class Dog < Animal
    partitioner :type, 'Dog'

    partitioner :deleted, false
  end
end
