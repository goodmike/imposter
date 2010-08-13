require 'generators/imposter'

module Imposter
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
	
	    extend TemplatePath 
	    
	    def create_test_imposter_directories
	      empty_directory 'test/imposter'
	      empty_directory 'test/imposter/config'
	      
      end
	    
	    def copy_rake_file
    		copy_file "databases.rake", "lib/tasks/databases.rake"
    	end
    	
    	def copy_models_file
    	  copy_file "models.yml", "test/imposter/config/models.yml"
  	  end
  	  
  	end
	end
end
