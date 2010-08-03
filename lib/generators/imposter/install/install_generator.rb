require 'generators/imposter'

module Imposter
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
	
	    extend TemplatePath 
	    
	    def create_test_imposter_directory
	      empty_directory 'test/imposter'
      end
	    
	    def copy_rake_file
    		puts "Creating lib/tasks/databases.rake"
    		copy_file "databases.rake", "lib/tasks/databases.rake"
    	end
    	
  	end
	end
end
