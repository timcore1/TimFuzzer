require 'yaml'

module TimFuzzer
  class Config
    DEFAULT_CONFIG = {
      'general' => {
        'timeout' => 30,
        'max_threads' => 10,
        'user_agent' => 'TimFuzzer/1.0',
        'follow_redirects' => true,
        'max_redirects' => 3
      },
      'proxy' => {
        'enabled' => false,
        'host' => '127.0.0.1',
        'port' => 8080,
        'username' => '',
        'password' => ''
      },
      'modules' => {
        'sql_injection' => {
          'enabled' => true,
          'timeout' => 10,
          'max_payloads' => 100
        },
        'xss' => {
          'enabled' => true,
          'timeout' => 10,
          'max_payloads' => 100
        },
        'lfi' => {
          'enabled' => true,
          'timeout' => 10,
          'max_payloads' => 50
        },
        'command_injection' => {
          'enabled' => true,
          'timeout' => 15,
          'max_payloads' => 50
        }
      },
      'reporting' => {
        'format' => 'json',
        'save_responses' => true,
        'max_response_size' => 10240
      }
    }

    def initialize(config_file = nil)
      @config = DEFAULT_CONFIG.dup
      load_config(config_file) if config_file
    end

    def get(*keys)
      value = @config
      keys.each do |key|
        value = value[key.to_s] if value.is_a?(Hash)
      end
      value
    end

    private

    def load_config(file)
      begin
        user_config = YAML.load_file(file)
        @config = deep_merge(@config, user_config)
      rescue => e
        puts "Ошибка при загрузке конфигурации: #{e.message}".colorize(:red)
        puts "Используются настройки по умолчанию".colorize(:yellow)
      end
    end

    def deep_merge(hash1, hash2)
      hash1.merge(hash2) do |key, old_val, new_val|
        if old_val.is_a?(Hash) && new_val.is_a?(Hash)
          deep_merge(old_val, new_val)
        else
          new_val
        end
      end
    end
  end
end 