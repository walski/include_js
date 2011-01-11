$LOAD_PATH << "#{File.dirname(__FILE__)}/../"
require 'def_js'

class Prime
  include DefJs
  
  def native_primes(n)
    results = []
    gestrichen = []
    
    for i in 2..n
      gestrichen[i] = false
    end
    
    for i in 2..n do
      if !gestrichen[i]
          results << i
          j = i * i
          while j <= n
            gestrichen[j] = true
            j += i
          end
      end
    end

    results
  end
  
  defjs %{primes(n)
    var results = [];
    var gestrichen = [];
    
    for (i = 2; i <= n; i++) {
      gestrichen[i] = false;
    }

    for (i = 2; i <= n; i++) {
      if (!gestrichen[i]) {
          results.push(i);
          for (j = i * i; j <= n; j += i) {
            gestrichen[j] = true;
          }
      }
    }

    return results;
  }
end


require 'benchmark'
prime = Prime.new

ruby_timing = Benchmark.realtime do
  prime.native_primes(100000)
end

js_timing = Benchmark.realtime do
  prime.primes(100000)
end

puts "Ruby: %0.4fs (%5.2fx JS   speed)" % [ruby_timing, js_timing / ruby_timing]
puts "JS:   %0.4fs (%5.2fx Ruby speed)" % [js_timing, ruby_timing / js_timing]