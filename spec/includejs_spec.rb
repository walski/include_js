require 'rubygems'
require 'rspec'

require 'includejs'

describe IncludeJs do
  it "can load a CommonJS module" do
    IncludeJs.require_root = 'spec/support'
    
    test_module = IncludeJs.require("test_module")
    
    test_module.plus(1, 2).should be 3
    test_module.minus(1, 2).should be -1
    test_module.minus(2, 1).should be 1
  end
end