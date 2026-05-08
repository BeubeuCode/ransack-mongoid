require_relative 'support'

seed!

puts '=' * 50
puts ' Basic Search (eq, cont, start, end)'
puts '=' * 50

show 'Exact match: category = "Electronics"',
  Product.search(category_eq: 'Electronics').result

show 'Contains: name contains "mouse" (case-insensitive)',
  Product.search(name_cont: 'mouse').result

show 'Starts with: name starts with "Web"',
  Product.search(name_start: 'Web').result

show 'Ends with: name ends with "HD"',
  Product.search(name_end: 'HD').result

show 'Does not contain: name does not contain "desk"',
  Product.search(name_not_cont: 'desk').result

show 'Term alias (name OR category contains "furn")',
  Product.search(term_cont: 'furn').result
