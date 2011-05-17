require 'includejs'

describe IncludeJs do
  Dir.glob('./spec/support/commonjs/tests/modules/1.0/**').each { |dir|
    spec = File.basename(dir)
    send 'it', "passes the Modules 1.0 '#{spec}' test" do
      outcome = []
      IncludeJs.root_path = dir
      env = IncludeJs.require('program', :print => lambda { |*args| outcome << args.first } )
      outcome.join.should_not include 'FAIL'
    end 
  }

end