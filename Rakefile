require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "urlsplease-imposter"
    gem.summary = "(Ruby 1.9 and Rails 3 ready) Real fake data"
    gem.email = "mh@michaelharrison.ws"
    gem.homepage = "http://github.com/urlsplease/imposter"
    gem.authors = ["Robert Hall", "Michael Harrison"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    gem.add_dependency "sqlite3-ruby", ">= 1.2.5"
    gem.add_dependency "faker", ">= 0"
    gem.add_dependency "fastercsv", ">= 0"
    gem.files.include %w(lib/generators/**/*.rb lib/imposter/*.rb lib/imposter/*.db generators/**/*.rb generators/templates/*)
    gem.description = %Q{Temporary fork of Robert Hall's imposter gem with Ruby 1.9 and Rails 3 support. Provides generators and rake tasks via YAML based imposters for schema level data faking}
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "imposter #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
