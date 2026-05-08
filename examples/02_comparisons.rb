require_relative 'support'

seed!

puts '=' * 50
puts ' Comparisons (gt, lt, gteq, lteq)'
puts '=' * 50

show 'Price > $100',
  Product.search(price_gt: 100).result

show 'Price <= $35',
  Product.search(price_lteq: 35).result

show 'Price between $25 and $75',
  Product.search(price_gteq: 25, price_lteq: 75).result

show 'Rating >= 4.5',
  Product.search(rating_gteq: 4.5).result

puts "\n#{'=' * 50}"
puts ' Boolean / null checks'
puts '=' * 50

show 'In stock = true',
  Product.search(in_stock_eq: true).result

show 'In stock = false',
  Product.search(in_stock_eq: false).result

show 'Rating is not null',
  Product.search(rating_not_null: true).result
