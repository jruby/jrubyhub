begin
  require 'rspec-rails'
  # RSpec-Rails deletes the default task, so re-add cucumber as part of
  # :default
  class AddToCucumberDefault < ::Rails::Railtie
    rake_tasks do
      task :default => :cucumber
    end
  end
rescue LoadError
end
