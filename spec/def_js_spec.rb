require 'rubygems'
require 'rspec'

require 'def_js'

describe DefJs do
  it "allows to declare a js method on an object" do
    class TestClass
      include DefJs
      
      defjs %{test_method
        var a = 5;
        
        return a * 6;
      }
    end
    
    test_obj = TestClass.new
    test_obj.should respond_to(:test_method)
    test_obj.test_method.should eql(30)
  end
  
  it "allows to declare js methods that take parameters" do
    class TestClassMultipleParameter
      include DefJs
      
      defjs %{test_method(a,b)
        return a * b + 2;
      }
    end
    
    test_obj = TestClassMultipleParameter.new
    test_obj.should respond_to(:test_method)
    test_obj.test_method(17, 23).should eql(17 * 23 + 2)
  end
  
  it "deals with trailing or leading spaces in method names" do
    class TestClassTrailingSpace
      include DefJs
      
      defjs %{test_method     
        return 1;
      }
    end
    
    class TestClassLeadingSpace
      include DefJs
      
      defjs %{     test_method
        return 1;
      }
    end
    
    class TestClassTrailingAndLeadingSpace
      include DefJs
      
      defjs %{         test_method     
        return 1;
      }
    end
    
    TestClassTrailingSpace.new.should respond_to(:test_method)
    TestClassLeadingSpace.new.should respond_to(:test_method)
    TestClassTrailingAndLeadingSpace.new.should respond_to(:test_method)
  end
  
  it "allows to export the model as a JS model" do
    class TestClassJsModelExport
      include DefJs
      
      def to_json
        "{\"a\": 5}"
      end
      
      defjs %{c(c1,c2)
        return (c1 * 10) + c2;
      }
    end
    
    test_obj = TestClassJsModelExport.new
    
    test_obj.to_js_model.should eql %{
var TestClassJsModelExport = {
  "a": 5,
  "c": function(c1, c2) {
    return (c1 * 10) + c2;
  }
}
    }.strip
  end
end

