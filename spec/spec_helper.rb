require 'mongoid'
require 'ransack'
require 'ransack/mongoid'

I18n.enforce_available_locales = false
Time.zone = 'Eastern Time (US & Canada)'
I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'support', '*.yml')]

Dir[File.expand_path('../{mongoid/helpers,mongoid/support}/*.rb', __FILE__)]
  .each { |f| require f }

RSpec.configure do |config|
  config.alias_it_should_behave_like_to :it_has_behavior, 'has behavior'

  config.before(:suite) do
    message = "Running Ransack specs with #{Mongoid.default_client.inspect
      }, Mongoid #{Mongoid::VERSION}, Mongo driver #{Mongo::VERSION}"
    line = '=' * message.length
    puts line, message, line
    Schema.create
  end

  config.include RansackHelper
end

RSpec::Matchers.define :be_like do |expected|
  match do |actual|
    actual.gsub(/^\s+|\s+$/, '').gsub(/\s+/, ' ').strip ==
      expected.gsub(/^\s+|\s+$/, '').gsub(/\s+/, ' ').strip
  end
end

RSpec::Matchers.define :have_attribute_method do |expected|
  match do |actual|
    actual.attribute_method?(expected)
  end
end
