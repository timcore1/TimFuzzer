module TimFuzzer
  class ModuleLoader
    MODULES_PATH = File.join(__dir__, '../../modules')
    
    class << self
      def load_modules(selected_modules = nil, config)
        modules = []
        
        Dir[File.join(MODULES_PATH, '*.rb')].each do |file|
          require file
          module_name = File.basename(file, '.rb')
          class_name = module_name.split('_').map(&:capitalize).join
          
          if should_load_module?(module_name, selected_modules, config)
            module_class = TimFuzzer.const_get("#{class_name}Module")
            modules << module_class.new(config)
          end
        end
        
        modules
      end
      
      def list_modules
        puts "\nДоступные модули:"
        Dir[File.join(MODULES_PATH, '*.rb')].each do |file|
          require file
          module_name = File.basename(file, '.rb')
          class_name = module_name.split('_').map(&:capitalize).join
          
          module_class = TimFuzzer.const_get("#{class_name}Module").new(Config.new)
          puts "- #{module_name}: #{module_class.description}"
        end
      end
      
      private
      
      def should_load_module?(module_name, selected_modules, config)
        return false unless config.get('modules', module_name, 'enabled')
        selected_modules.nil? || selected_modules.include?(module_name)
      end
    end
  end
end 