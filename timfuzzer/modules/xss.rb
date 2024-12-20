require_relative '../lib/timfuzzer/base_module'
require 'cgi'

module TimFuzzer
  class XssModule < BaseModule
    def initialize(config = nil)
      super
      @name = "XSS Scanner"
      @description = "Модуль для поиска XSS-уязвимостей"
      @payloads = load_payloads
    end
    
    def run(url, agent)
      results = []
      
      @payloads.each do |payload|
        begin
          encoded_payload = URI.encode_www_form_component(payload)
          response = agent.get("#{url}#{encoded_payload}")
          if vulnerable?(response, payload)
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
      File.readlines(File.join(__dir__, '../payloads/xss.txt')).map(&:chomp)
    end
    
    def vulnerable?(response, payload)
      response.body.include?(payload) && 
      !response.body.include?(CGI.escapeHTML(payload))
    end
  end
end 