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
    association :phone_numbers, model: PhoneNumbers,
                                on: { type: :reference, name: :demographic_id, parent: :id }
  end

  class MembersBase < Dbee::Base
    association :demos, model: Demographics,
                        on: { type: :reference, name: :member_id, parent: :id }

    association :movies, model: Movies,
                         on: { type: :reference, name: :member_id, parent: :id }
  end

  class Members < MembersBase
    association :favorite_comic_movies, model: Movies, on: [
      { type: :reference, name: :member_id, parent: :id },
      { type: :static, name: :genre, value: 'comic' }
    ]

    association :favorite_mystery_movies, model: Movies, on: [
      { type: :reference, name: :member_id, parent: :id },
      { type: :static, name: :genre, value: 'mystery' }
    ]

    association :favorite_comedy_movies, model: Movies, on: [
      { type: :reference, name: :member_id, parent: :id },
      { type: :static, name: :genre, value: 'comedy' }
    ]
  end

  class TheatersBase < Dbee::Base
    boolean_column :active, nullable: false
  end

  class Theaters < TheatersBase
    boolean_column :inspected

    association :members, model: Members, on: [
      { type: :reference, name: :tid, parent: :id },
      { type: :reference, name: :partition, parent: :partition }
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
