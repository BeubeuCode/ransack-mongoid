require 'ransack/adapters/mongoid/ransack/context'
require 'ransack/adapters/mongoid/ransack/visitor'
require 'ransack/adapters/mongoid/ransack/constants'
require 'ransack/adapters/mongoid/ransack/translate'
require 'ransack/adapters/mongoid/ransack/nodes/condition'

require 'ransack/adapters/mongoid/base'
::Mongoid::Document.send :include, Ransack::Adapters::Mongoid::Base

require 'ransack/adapters/mongoid/attributes/attribute'
require 'ransack/adapters/mongoid/table'
require 'ransack/adapters/mongoid/inquiry_hash'

require 'ransack/adapters/mongoid/context'

Ransack::SUPPORTS_ATTRIBUTE_ALIAS = false

# Re-register cont/start/end predicates with MongoDB regex formatters.
# Ransack's defaults use SQL LIKE (%value%) via escape_wildcards; MongoDB
# needs plain Regexp.escape so the Attribute#matches method gets a clean pattern.
Ransack.configure do |config|
  {
    'cont'      => proc { |v| Regexp.escape(v.to_s) },
    'not_cont'  => proc { |v| Regexp.escape(v.to_s) },
    'start'     => proc { |v| "\\A#{Regexp.escape(v.to_s)}" },
    'not_start' => proc { |v| "\\A#{Regexp.escape(v.to_s)}" },
    'end'       => proc { |v| "#{Regexp.escape(v.to_s)}\\Z" },
    'not_end'   => proc { |v| "#{Regexp.escape(v.to_s)}\\Z" },
  }.each do |name, formatter|
    arel_pred = name.start_with?('not_') ? 'does_not_match' : 'matches'
    config.add_predicate name, arel_predicate: arel_pred, formatter: formatter
  end
end
