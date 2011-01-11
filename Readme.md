# defjs: Add JavaScript methods to your Ruby classes

## Features
- Write methods in JS and use them in Ruby like normal methods:

      class Sample
        include DefJs
    
        defjs %{sample(a,b)
          "This is a sample: " + a + ", " + b;
        }
      end
  
      my_sample = Sample.new
      my_sample.sample(3,6) # => "This is a sample: 3, 6"
  
- Export your class to a JS object which contains all the JS methods:

      # Re-open class to add a simple, empty to_json method
      class Sample
        def to_json
          "{}"
        end
      end
  
      # Export the class:
      my_sample.to_js_model
      
## Use case
defjs is build to use and pass models around seamlessly from a Ruby server
to a JS client.

## Speed
Simple benchmarks are showing a noticeable gain of speed when using JS methods
instead of native Ruby ones. While the Google V8 seems to be 10x faster than 
Ruby 1.8.7 it is still 4x as fast as Ruby 1.9.2

Check the sample files.

## Installation
Bundler is not yet integrated. Please install the dependencies first:

    gem install json
    gem install therubyracer
  
Now just run one of the sample files

    ruby samples/primes.rb