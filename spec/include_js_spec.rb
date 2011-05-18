require 'include_js'
IncludeJS.root_path = './spec/support'

describe IncludeJS do
  it "can load a CommonJS module" do        
    test_module = IncludeJS.require('test_module')
    
    test_module.plus(1, 2).should be 3
    test_module.minus(1, 2).should be -1
    test_module.minus(2, 1).should be 1
    
    test_module.square(4).should be 16
  end
  
  it "can include a ruby like JS modul" do
    class TestClass
      include IncludeJS.module('test_module')
    end
    
    test = TestClass.new
    
    test.plus(1, 2).should be 3
    test.minus(1, 2).should be -1
    test.minus(2, 1).should be 1

    test.square(4).should be 16
  end
  
end