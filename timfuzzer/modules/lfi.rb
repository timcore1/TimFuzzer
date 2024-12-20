require_relative '../lib/timfuzzer/base_module'

module TimFuzzer
  class LFIModule < BaseModule
    def initialize
      super
      @name = "LFI Scanner"
      @description = "Модуль для поиска уязвимостей локального включения файлов"
      @payloads = load_payloads
      @signatures = [
        '/etc/passwd',
        'root:x:0:0',
        'WIN.INI',
        '[boot loader]'
      ]
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
      File.readlines(File.join(__dir__, '../payloads/lfi.txt')).map(&:chomp)
    end
    
    def vulnerable?(response)
      @signatures.any? { |sig| response.body.include?(sig) }
    end
  end
end 