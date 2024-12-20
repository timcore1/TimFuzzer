module TimFuzzer
  class Reporter
    def initialize(output_file)
      @output_file = output_file
      @results = {}
    end
    
    def add_results(module_name, results)
      @results[module_name] = results if results.any?
    end
    
    def save
      File.open(@output_file, 'w') do |f|
        f.write(JSON.pretty_generate({
          scan_date: Time.now,
          total_vulnerabilities: count_vulnerabilities,
          results: @results
        }))
      end
    end
    
    private
    
    def count_vulnerabilities
      @results.values.map(&:size).sum
    end
  end
end 