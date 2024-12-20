require_relative '../lib/timfuzzer/base_module'

module TimFuzzer
  class SQLInjectionModule < BaseModule
    def initialize
      super
      @name = "SQL Injection Scanner"
      @description = "Модуль для поиска SQL-инъекций"
      @payloads = load_payloads
    end
    
    def run(url, agent)
      results = []
      
      @payloads.each do |payload|
        begin
          response = agent.get("#{url}#{payload}")
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
      File.readlines(File.join(__dir__, '../payloads/sql_injection.txt')).map(&:chomp)
    end
    
    def vulnerable?(response)
      response.body.include?('SQL syntax') || 
      response.body.include?('mysql_fetch_array') ||
      response.body.include?('ORA-01756')
    end
  end
end 