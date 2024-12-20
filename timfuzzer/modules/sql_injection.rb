require_relative '../lib/timfuzzer/base_module'

module TimFuzzer
  class SqlInjectionModule < BaseModule
    def initialize(config = nil)
      super
      @name = "SQL Injection Scanner"
      @description = "Модуль для поиска SQL-инъекций"
      @payloads = load_payloads
      @signatures = [
        'mysql_fetch_array()',
        'You have an error in your SQL syntax',
        'ORA-01756',
        'SQLite3::SQLException',
        'System.Data.SQLite.SQLiteException'
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
      File.readlines(File.join(__dir__, '../payloads/sql_injection.txt')).map(&:chomp)
    end
    
    def vulnerable?(response)
      @signatures.any? { |sig| response.body.include?(sig) }
    end
  end
end 