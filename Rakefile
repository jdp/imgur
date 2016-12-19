require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "imgur"
    gem.summary = %Q{Imgur API interface}
    gem.description = %Q{An interface to the Imgur API}
    gem.email = "jdp34@njit.edu"
    gem.homepage = "http://github.com/jdp/imgur"
    gem.authors = ["Justin Poliey"]
    gem.licenses = ["MIT"]
    gem.add_development_dependency "bacon", ">= 1.1.0"
    gem.add_development_dependency "yard", ">= 0.2.3.5"
    gem.add_development_dependency "curb", ">= 0.5.4.0"
    gem.add_development_dependency "crack", ">= 0.1.4"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |spec|
    spec.libs << 'spec'
    spec.pattern = 'spec/**/*_spec.rb'
    spec.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :spec => :check_dependencies

task :default => :spec

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
