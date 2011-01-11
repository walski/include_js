$LOAD_PATH << "#{File.dirname(__FILE__)}/../"
require 'def_js'

class Hybrid
  include DefJs
  
  def to_json
    '{"a": "Hallo"}'
  end
  
  defjs %{fib(n)
    if (n <= 2) {
      return 1;
    } else {
      return this.fib(n-1) + this.fib(n-2);
    }
  }
  
  def native_fib(n)
    return 1 if n <= 2
    
    native_fib(n - 1) + native_fib(n - 2)
  end
  
end


require 'benchmark'

hybrid = Hybrid.new

js_timing = Benchmark.realtime do
  hybrid.fib(35)
end

ruby_timing = Benchmark.realtime do
  hybrid.native_fib(35)
end

puts "JS:   %0.4f" % js_timing
puts "Ruby: %0.4f" % ruby_timing

puts hybrid.to_js_model