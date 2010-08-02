require 'rubygems'
# require 'activerecord'
require 'pathname'
# require 'activesupport'
require 'fileutils'

require 'generators/imposter'

module Imposter
  module Generators
    class GenModelsGenerator < ::Rails::Generators::Base
	
	    extend TemplatePath 

	    dbc = YAML.load(File.read('config/database.yml'))
    	conn = ActiveRecord::Base.establish_connection(dbc["development"])

      # Public models automatically executed
    	def genmodels
    		#create_rake_file
    		models_dir = Dir.glob(Rails.root.join('app', 'models').to_s + "/*.rb")
    		models_dir.each do |model_dir|
    			genmodel(model_dir)
    		end	
    	end

      protected
      
      def genmodel(model_name)
    		mn = Pathname.new(model_name).basename.to_s.chomp(File.extname(model_name))
    		require model_name

    		yaml_file = Rails.root.join('test', 'imposter').to_s + "/%03d" % eval(mn.camelcase).reflections.count + "-" + mn  + ".yml"
    		if (not File.exists? yaml_file) || options[:collision] == :force
    		  puts " ** YAML file is #{yaml_file}"
    			puts " ** #{mn}"
    			mh = Hash.new
    			ma = Hash.new
    			mf = Hash.new
    			eval(mn.camelcase).columns.each do |mod|
    				if mod.name.include? "_id" then
    					vl = "@" + mod.name.sub("_id","").pluralize + "[rand(@" + mod.name.sub('_id','').pluralize + ".length)][1]"
    					mh = {mod.name => vl}
    					ma.merge!(mh)
    				else
    					case mod.type.to_s.downcase
    						when 'string'
    						  if mod.name =~ /phone/
    						    v1 = 'Imposter::Phone.number("###-###-####")'
  						    else
      							case (1 + rand(3))
      								when 1					
      									vl = 'Imposter::Noun.multiple'
      								when 2
      									vl = 'Imposter::Animal.one'
      								when 3 
      									vl = 'Imposter::Vegtable.multiple'
      								when 4 
      									vl = 'Imposter::Mineral.one'
      							end
    							end
    						when 'text' then 
    							vl = 'Faker::Lorem.sentence(3)'
    						when 'integer' then
    							vl = 'i.to_s'
    						when 'datetime' 
    							vl = 'Date.today.to_s'
    						when 'date'
    							vl = 'Date.today.to_s'
    						when 'decimal' then
    							vl = 'rand(50).to_s + "." + (1000+rand(2000)).to_s'
    						else
    							puts "=-------=============> " + mod.type.to_s.downcase
    					end
    					if not mod.name.include? "_at" and :include_special	
    						mh = {mod.name => vl}
    						ma.merge!(mh)
    					end
    				end
    			end
    			mf.merge!(mn => {"fields" => ma})
    			mf[mn].merge!({"quantity" => 10})
    			File.open(yaml_file,"w") do |out|
    				YAML.dump(mf,out)  
    			end
    		else
    			puts " ** " + mn + " --skipped"	
    		end
    	end

    	def banner
    		"Usage: #{$0} #{spec.name} [options]"
    	end

      def add_options!(opt)
           opt.on('-f', '--force') { |value| options[:force] = value }
      end
      
    end
  end
end
