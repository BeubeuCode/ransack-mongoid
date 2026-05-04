require 'mongoid'
require 'ransack'
require 'ransack/mongoid'

Mongoid.configure do |config|
  config.clients.default = {
    hosts: [ENV.fetch('MONGODB_HOST', 'localhost') + ':27017'],
    database: 'ransack_mongoid_demo'
  }
end

Mongo::Logger.logger.level = Logger::WARN

class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,      type: String
  field :category,  type: String
  field :price,     type: Float
  field :in_stock,  type: Boolean, default: true
  field :rating,    type: Float

  belongs_to :brand, optional: true

  ransack_alias :term, :name_or_category

  ransacker :name_length do |parent|
    parent.table[:name]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name category price in_stock rating created_at]
  end

  def self.ransortable_attributes(auth_object = nil)
    %w[name price rating created_at]
  end

  def self.ransackable_scopes(auth_object = nil)
    [:affordable]
  end

  scope :affordable, -> { where(:price.lte => 50) }
end

class Brand
  include Mongoid::Document

  field :name, type: String

  has_many :products

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end

def seed!
  Mongoid.purge!

  acme  = Brand.create!(name: 'Acme')
  globo = Brand.create!(name: 'Globocorp')

  [
    { name: 'Wireless Mouse',    category: 'Electronics', price: 29.99, in_stock: true,  rating: 4.5, brand: acme  },
    { name: 'Mechanical Keyboard', category: 'Electronics', price: 89.99, in_stock: true,  rating: 4.8, brand: acme  },
    { name: 'USB-C Hub',         category: 'Electronics', price: 45.00, in_stock: false, rating: 3.9, brand: globo },
    { name: 'Standing Desk',     category: 'Furniture',   price: 349.00,in_stock: true,  rating: 4.2, brand: globo },
    { name: 'Desk Lamp',         category: 'Furniture',   price: 24.99, in_stock: true,  rating: 3.5, brand: acme  },
    { name: 'Webcam HD',         category: 'Electronics', price: 69.99, in_stock: true,  rating: 4.1, brand: globo },
    { name: 'Laptop Stand',      category: 'Electronics', price: 34.99, in_stock: false, rating: 4.6, brand: acme  },
    { name: 'Monitor 27"',       category: 'Electronics', price: 299.99,in_stock: true,  rating: 4.7, brand: globo },
    { name: 'Ergonomic Chair',   category: 'Furniture',   price: 499.00,in_stock: true,  rating: 4.9, brand: acme  },
    { name: 'Mouse Pad XL',      category: 'Accessories', price: 14.99, in_stock: true,  rating: 4.0, brand: globo },
  ].each { |attrs| Product.create!(attrs) }
end

def show(label, results)
  puts "\n#{label}"
  puts '-' * label.length
  if results.empty?
    puts '  (no results)'
  else
    results.each { |p| puts "  %-25s %-15s $%-8.2f rating: #{p.rating}" % [p.name, p.category, p.price] }
  end
end
