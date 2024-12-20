require 'mechanize'
require 'parallel'
require 'json'
require_relative 'timfuzzer/module_loader'
require_relative 'timfuzzer/scanner'
require_relative 'timfuzzer/reporter'
require_relative 'timfuzzer/config'

module TimFuzzer
  class Scanner
    attr_reader :url, :options, :agent
    
    def initialize(url, options = {})
      @url = url
      @options = options
      @config = Config.new(options[:config])
      setup_agent
      @modules = load_modules
      @reporter = Reporter.new(options[:output])
    end
    
    def run
      puts "Начинаем сканирование #{url}..."
      
      Parallel.each(@modules, in_threads: @config.get('general', 'max_threads')) do |mod|
        results = mod.run(url, agent)
        @reporter.add_results(mod.name, results)
      end
      
      @reporter.save
      puts "Сканирование завершено. Отчет сохранен в #{options[:output]}"
    end
    
    private
    
    def setup_agent
      @agent = Mechanize.new
      @agent.user_agent = @config.get('general', 'user_agent')
      @agent.max_history = 0
      @agent.open_timeout = @config.get('general', 'timeout')
      @agent.read_timeout = @config.get('general', 'timeout')
      
      if @config.get('proxy', 'enabled')
        @agent.set_proxy(
          @config.get('proxy', 'host'),
          @config.get('proxy', 'port'),
          @config.get('proxy', 'username'),
          @config.get('proxy', 'password')
        )
      end
    end
    
    def load_modules
      ModuleLoader.load_modules(options[:modules], @config)
    end
  end
end 