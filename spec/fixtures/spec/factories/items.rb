# +------------------------------------------------------------------------------------+
# |                                       items                                        |
# +-----------------------+-----------+------------------+---------+-------+-----+-----+
# | Column                | Ruby Type | DB Type          | Default | Null? | PK? | FK? |
# +-----------------------+-----------+------------------+---------+-------+-----+-----+
# | id                    | bigint    | integer          |    -    |   N   |  Y  |  N  |
# | category_id           | integer   | integer          |    -    |   N   |  N  |  N  |
# | manufacturer_name     | string    | varchar(55)      |    -    |   Y   |  N  |  N  |
# | manufacturer_location | string    | varchar(155)     |    -    |   N   |  N  |  Y  |
# | name                  | string    | varchar(125)     |   Car   |   N   |  Y  |  N  |
# | price                 | float     | double precision |   1.0   |   Y   |  N  |  N  |
# +-----------------------+-----------+------------------+---------+-------+-----+-----+

FactoryBot.define do
  factory :item do
    name { "car" }
  end
end
