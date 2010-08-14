require 'pathname'
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
    		models_dir = Dir.glob(Rails.root.join('app', 'models').to_s + "/*.rb")
    		empty_directory 'test/imposter' # in case it doesn't exist yet
        read_config_file

    		models_dir.each do |model_dir|
    			genmodel(model_dir)
    		end	
    	end

      protected
      
      def read_config_file
        @models_config = YAML.load(
          File.open(
            Rails.root.join('test', 'imposter', 'config', 'models.yml')))
        @models_config["default_quantity"] ||= 10
      end
      
      def quantity_for(model_name)
        model_name = model_name.camelcase
        if @models_config["quantities"] && @models_config["quantities"][model_name]
          @models_config["quantities"][model_name]
        elsif @models_config["default_quantity"]
          @models_config["default_quantity"]
        else
          10
        end
      end
      
    	def unique?(col_name)
    	  @models_config["unique"] && @models_config["unique"].include?(col_name)
  	  end
      
      def foreign_key_id(fkey_id)
        model_name = fkey_id.sub("_id","")
        "(rand(#{quantity_for(model_name)}) + 1).to_s"
      end
      
      def limited_choices_for(col_name)
        if @models_config["choices"] && @models_config["choices"][col_name]
          "#{@models_config["choices"][col_name]}.rand"
        else
          nil
        end
      end
      
      def skip?(model_name)
        @models_config["skip"] && @models_config["skip"].include?(model_name)
      end
      
      def genmodel(model_name)
    		mn = Pathname.new(model_name).basename.to_s.chomp(File.extname(model_name))
    		classname = mn.camelcase
    		return false if skip?(classname)
    		require model_name
    		klass = classname.constantize
    		return false unless klass.is_a? Class

    		yaml_file = Rails.root.join('test', 'imposter').to_s + "/%03d" % klass.reflections.count + "-" + mn  + ".yml"
    		if (not File.exists? yaml_file) || options[:collision] == :force
    			mh = Hash.new
    			ma = Hash.new
    			mf = Hash.new
    			klass.columns.each do |mod|
    				if mod.name.include? "_id" then
    					vl = foreign_key_id(mod.name)
    				else
    					case mod.type.to_s.downcase
    						when 'string'
    						  unless vl = limited_choices_for(mod.name)
    						    if unique?(mod.name)
    						      vl = '@column_name + Imposter::Mineral.one() + @i'
      						  elsif mod.name =~ /phone/
      						    vl = 'Imposter::Phone.number("###-###-####")'
      						  elsif mod.name =~ /url/
      						    vl = 'Imposter.urlify()'
      						  elsif mod.name =~ /email/
      						    vl = 'Imposter.email_address(@i)'
    						    else
    						      vl = generic_string()
      							end
    							end
    						when 'text' then 
    							vl = 'Faker::Lorem.sentence(3)'
    						when 'integer' then
    							vl = '@i'
    						when 'datetime' 
    							vl = 'Date.today.to_s()'
    						when 'date'
    							vl = 'Date.today.to_s()'
    						when 'decimal' then
    							vl = 'rand(50).to_s() + "." + (1000+rand(2000)).to_s()'
    						else
    							puts " ** unable to imposter " + mod.type.to_s.downcase
    					end
  					end
  					if not mod.name.include? "_at" and :include_special	
  						mh = {mod.name => "<%= #{vl} %>"}
  						ma.merge!(mh)
    				end
    			end
    			mf.merge!(mn => {"fields" => ma})
    			mf[mn].merge!({"quantity" => quantity_for(mn)})
    			File.open(yaml_file,"w") do |out|
    				YAML.dump(mf,out)  
    			end
    		else
    			puts " ** " + mn + " --skipped"	
    		end
    	end
    	
    	def generic_string
				%w{
				    Imposter::Noun
  				  Imposter::Animal
  				  Imposter::Vegetable
  				  Imposter::Mineral
  				}.rand + %w{
  				  .one()
  				  .multiple()
  				}.rand
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
