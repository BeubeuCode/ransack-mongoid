require 'mongoid'

Mongoid.load!(File.expand_path("../mongoid.yml", __FILE__), :test)
Mongo::Logger.logger.level = Logger::WARN if defined?(Mongo)
Mongoid.purge!

class Person
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :email, type: String
  field :only_search, type: String
  field :only_sort, type: String
  field :only_admin, type: String
  field :salary, type: Integer
  field :awesome, type: Boolean, default: false

  belongs_to :parent, :class_name => 'Person', inverse_of: :children, optional: true
  has_many   :children, :class_name => 'Person', inverse_of: :parent

  has_many   :articles
  has_many   :comments

  ransack_alias :term, :name_or_email

  # has_many   :authored_article_comments, :through => :articles,
             # :source => :comments, :foreign_key => :person_id

  has_many   :notes, :as => :notable

  default_scope -> { order(id: :desc) }

  scope :restricted,  lambda { where(restricted: 1) }
  scope :active,      lambda { where(active: 1) }
  scope :over_age,    lambda { |y| where('age' => { '$gt' => y }) }

  ransacker :reversed_name, :formatter => proc { |v| v.reverse } do |parent|
    parent.table[:name]
  end

  ransacker :doubled_name do |parent|
    # Arel::Nodes::InfixOperation.new(
    #   '||', parent.table[:name], parent.table[:name]
    #   )
    parent.table[:name]
  end

  def self.ransackable_attributes(auth_object = nil)
    if auth_object == :admin
      all_ransackable_attributes - ['only_sort']
    else
      all_ransackable_attributes - ['only_sort', 'only_admin']
    end
  end

  def self.ransortable_attributes(auth_object = nil)
    if auth_object == :admin
      all_ransackable_attributes - ['only_search']
    else
      all_ransackable_attributes - ['only_search', 'only_admin']
    end
  end
end

class Musician < Person
end

class Article
  include Mongoid::Document

  field :title, type: String
  field :body, type: String

  belongs_to :person, optional: true
  has_many :comments
  # has_and_belongs_to_many :tags
  has_many :notes, :as => :notable
end

module Namespace
  class Article < ::Article

  end
end

class Comment
  include Mongoid::Document

  field :body, type: String


  belongs_to :article, optional: true
  belongs_to :person, optional: true
end

class Tag
  include Mongoid::Document

  field :name, type: String

  # has_and_belongs_to_many :articles
end

class Note
  include Mongoid::Document

  field :note, type: String

  belongs_to :notable, :polymorphic => true, optional: true
end

module Schema
  def self.create
    10.times do |i|
      person = Person.create!(
        name: "Person #{i}",
        email: "person#{i}@example.com",
        salary: 30_000 + i * 1_000,
        only_search: "search #{i}",
        only_sort: "sort #{i}",
        only_admin: "admin #{i}"
      )
      Note.create!(note: "person note #{i}", notable: person)
      3.times do |j|
        article = Article.create!(title: "Article #{j} for #{i}", body: "body #{j}", person: person)
        Note.create!(note: "article note #{j}", notable: article)
        10.times { |k| Comment.create!(body: "comment #{k}", article: article, person: person) }
      end
    end

    Comment.create!(body: 'First post!', article: Article.create!(title: 'Hello, world!'))
  end
end
