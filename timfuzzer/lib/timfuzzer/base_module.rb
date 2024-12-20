module TimFuzzer
  class BaseModule
    attr_reader :name, :description, :config
    
    def initialize(config)
      @name = self.class.name
      @description = "Базовый модуль фаззинга"
      @config = config
    end
    
    def run(url, agent)
      raise NotImplementedError, "Каждый модуль должен реализовать метод run"
    end
    
    protected
    
    def log_vulnerability(url, payload, response)
      result = {
        url: url,
        payload: payload,
        response_code: response.code,
        timestamp: Time.now
      }
      
      if @config.get('reporting', 'save_responses')
        max_size = @config.get('reporting', 'max_response_size')
        result[:response_body] = response.body[0..max_size]
      end
      
      result
    end
    
    def module_config
      module_name = self.class.name.split('::').last.gsub(/Module$/, '').
                   gsub(/(.)([A-Z])/, '\1_\2').downcase
      @config.get('modules', module_name)
    end
  end
end 