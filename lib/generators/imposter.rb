module Imposter
  module Generators
    module TemplatePath
      def source_root
        @_imposter_source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'imposter', generator_name, 'templates'))
      end
    end
    
    class ModelsConfig
            
      def quantity_for(model_name)
        @quantites["model_name"] || @default_quantity
      end
      
    end
    
  end
end