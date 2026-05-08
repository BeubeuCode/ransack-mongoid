require_relative 'support'

seed!

puts '=' * 50
puts ' Groupings (AND / OR)'
puts '=' * 50

show 'Electronics AND price <= $50 (AND grouping)',
  Product.search(
    category_eq: 'Electronics',
    price_lteq:  50
  ).result

show 'name = "Desk Lamp" OR name = "Webcam HD" (OR grouping)',
  Product.search(
    m:          'or',
    name_eq:    'Desk Lamp',
    price_lteq: 30
  ).result

show 'Nested groupings: (category=Furniture OR price > 200) via g:',
  Product.search(
    g: [
      { m: 'or', category_eq: 'Furniture', price_gt: 200 }
    ]
  ).result

show '_any combinator: name = "Desk Lamp" OR "Webcam HD"',
  Product.search(name_eq_any: ['Desk Lamp', 'Webcam HD']).result

show '_all combinator: price in all of [$29.99]',
  Product.search(price_eq_all: [29.99]).result
