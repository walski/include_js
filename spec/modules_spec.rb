require 'includejs'

describe IncludeJs do
  Dir.glob('./spec/support/commonjs/tests/modules/1.0/**').each { |dir|
    spec = File.basename(dir)
    send 'it', "passes the #{spec} test" do
      # TODO Make failing tests fail!
      IncludeJs.root_path = dir
      IncludeJs.require('program')
    end 
  }

end