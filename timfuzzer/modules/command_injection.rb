require_relative '../lib/timfuzzer/base_module'

module TimFuzzer
  class CommandInjectionModule < BaseModule
    def initialize
      super
      @name = "Command Injection Scanner"
      @description = "Модуль для поиска уязвимостей внедрения команд"
      @payloads = load_payloads
      @signatures = [
        'uid=',
        'root:',
        'PATH=',
        'Volume Serial Number',
        'Directory of'
      ]
    end
    
    def run(url, agent)
      results = []
      
      @payloads.each do |payload|
        begin
          encoded_payload = URI.encode_www_form_component(payload)
          response = agent.get("#{url}#{encoded_payload}")
          if vulnerable?(response)
            results << log_vulnerability(url, payload, response)
          end
        rescue => e
          puts "Ошибка при тестировании #{url} с payload #{payload}: #{e.message}"
        end
      end
      
      results
    end
    
    private
    
    def load_payloads
      File.readlines(File.join(__dir__, '../payloads/command_injection.txt')).map(&:chomp)
    end
    
    def vulnerable?(response)
      @signatures.any? { |sig| response.body.include?(sig) }
    end
  end
end 