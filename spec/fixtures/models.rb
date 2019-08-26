# frozen_string_literal: true

#
# Copyright (c) 2019-present, Blue Marble Payroll, LLC
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.
#

module Models
  class Movies < Dbee::Base
  end

  class PhoneNumbers < Dbee::Base
  end

  class Demographics < Dbee::Base
    association :phone_numbers, model: 'Models::PhoneNumbers',
                                constraints: {
                                  name: :demographic_id,
                                  parent: :id
                                }
  end

  class MembersBase < Dbee::Base
    association :demos, model: Demographics,
                        constraints: { type: :reference, name: :member_id, parent: :id }

    association :movies, model: Movies,
                         constraints: { name: :member_id, parent: :id }
  end

  class Members < MembersBase
    association :favorite_comic_movies, model: Movies, constraints: [
      { type: :reference, name: :member_id, parent: :id },
      { type: :static, name: :genre, value: 'comic' }
    ]

    association :favorite_mystery_movies, model: Movies, constraints: [
      { type: :reference, name: :member_id, parent: :id },
      { type: :static, name: :genre, value: 'mystery' }
    ]

    association :favorite_comedy_movies, model: Movies, constraints: [
      { type: :reference, name: :member_id, parent: :id },
      { type: :static, name: :genre, value: 'comedy' }
    ]
  end

  class TheatersBase < Dbee::Base
    association :members, model: Members, constraints: [
      { type: :reference, name: :tid, parent: :id },
      { type: :reference, name: :partition, parent: :partition }
    ]
  end

  class Theaters < TheatersBase
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

  class C < A
  end

  class D < A
    table ''
  end

  class E < B
    table 'table_set_to_e'
  end
end

module ReadmeDataModels
  class PhoneNumbers < Dbee::Base
    table :phones
  end

  class Notes < Dbee::Base
  end

  class Patients < Dbee::Base
    association :notes, model: Notes, constraints: {
      type: :reference, name: :patient_id, parent: :id
    }

    association :work_phone_number, model: PhoneNumbers, constraints: [
      { type: :reference, name: :patient_id, parent: :id },
      { type: :static, name: :phone_number_type, value: 'work' }
    ]

    association :cell_phone_number, model: PhoneNumbers, constraints: [
      { type: :reference, name: :patient_id, parent: :id },
      { type: :static, name: :phone_number_type, value: 'cell' }
    ]

    association :fax_phone_number, model: PhoneNumbers, constraints: [
      { type: :reference, name: :patient_id, parent: :id },
      { type: :static, name: :phone_number_type, value: 'fax' }
    ]
  end

  class Practices < Dbee::Base
    association :patients, model: Patients, constraints: {
      type: :reference, name: :practice_id, parent: :id
    }
  end
end

module Cycles
  class A < Dbee::Base
    association :b, model: 'Cycles::B'

    association :c, model: 'Cycles::C'

    association :d, model: 'Cycles::D'

    association :g, model: 'Cycles::G'
  end

  class B < Dbee::Base
    association :b1, model: 'Cycles::B'

    association :b2, model: 'Cycles::B'
  end

  class C < Dbee::Base
    association :e, model: 'Cycles::E'
  end

  class D < Dbee::Base
    association :f, model: 'Cycles::F'
  end

  class E < Dbee::Base
    association :g, model: 'Cycles::G'
  end

  class F < Dbee::Base
    association :a, model: 'Cycles::A'
  end

  class G < Dbee::Base
    association :g, model: 'Cycles::G'
  end
end
