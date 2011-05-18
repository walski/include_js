# IncludeJS - Use CommonJS modules inside Ruby (via therubyracer / V8)

This is an experiment to see if we can use CommonJS Modules inside Ruby.

Currently it supports the CommonJS Modules 1.0 spec (http://www.commonjs.org/specs/modules/1.0/).


## Synopsis
Writing your JavaScript code in a CommonJS Module way is very easy. See spec/support for examples.

Load a Module

    helpers = IncludeJS.require('helpers') # This returns a V8::Object
    helpers.foo # => 42

Alternatively you can use the 'module' method, which returns a basic Ruby Module.

    class App
      include IncludeJS.require('helpers')
    end
    App.new.foo # => 42

You can set one root path from where to load .js files

    IncludeJS.root_path = 'my/app/javascripts'


Have fun.


## Run the specs
    git submodule update --init
    bundle install
    bundle rspec spec    

## Speed
Simple benchmarks are showing a noticeable gain of speed when using JS methods
instead of native Ruby ones. While the Google V8 seems to be 10x faster than 
Ruby 1.8.7 it is still 4x as fast as Ruby 1.9.2

