require 'generators/imposter'

module Imposter
  module Generators
    class InstallGenerator < ::Rails::Generator::Base
	
	    extend TemplatePath 
	        	
	    def copy_rake_file
    		puts "Creating lib/tasks/databases.rake"
    		copy_file "databases.rake", "lib/tasks/databases.rake"
    	end
    	
  	end
	end
end
