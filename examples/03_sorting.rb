require_relative 'support'

seed!

puts '=' * 50
puts ' Sorting'
puts '=' * 50

show 'Sort by price ASC',
  Product.search(s: 'price asc').result

show 'Sort by price DESC',
  Product.search(s: 'price desc').result

show 'Sort by rating DESC',
  Product.search(s: 'rating desc').result

show 'Sort by name ASC',
  Product.search(s: 'name asc').result

show 'Filter Electronics + sort by price ASC',
  Product.search(category_eq: 'Electronics', s: 'price asc').result
