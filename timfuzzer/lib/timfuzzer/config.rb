require 'yaml'

module TimFuzzer
  class Config
    def initialize(config_file = nil)
      @config_file = config_file || File.join(__dir__, '../../config/config.yml')
      load_config
    end
    
    def load_config
      @config = YAML.load_file(@config_file)
    rescue => e
      puts "Ошибка загрузки конфигурации: #{e.message}"
      @config = default_config
    end
    
    def get(section, key = nil)
      return @config[section] if key.nil?
      @config.dig(section, key)
    end
    
    private
    
    def default_config
      {
        'general' => {
          'timeout' => 30,
          'max_threads' => 5,
          'user_agent' => 'TimFuzzer/1.0',
          'follow_redirects' => true
        }
      }
    end
  end
end 