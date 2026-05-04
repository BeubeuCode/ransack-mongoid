require_relative 'support'

seed!

puts '=' * 50
puts ' Scope integration'
puts '=' * 50

# Scopes must be whitelisted in ransackable_scopes
# Product.ransackable_scopes => [:affordable]  (price <= $50)

show 'Scope "affordable" (price <= $50) enabled',
  Product.search(affordable: true).result

show 'Scope "affordable" disabled (false = ignored)',
  Product.search(affordable: false).result

show 'Scope "affordable" + contains "mouse"',
  Product.search(affordable: true, name_cont: 'mouse').result

# Unlisted scopes are ignored for security
puts "\n--- Unlisted scope is silently ignored ---"
puts "Product.search(nonexistent_scope: true).result.count => #{Product.search(nonexistent_scope: true).result.count} (all products)"
