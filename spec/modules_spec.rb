require 'includejs'

describe IncludeJs do
  Dir.glob('./spec/support/commonjs/tests/modules/1.0/**').each { |dir|
    spec = File.basename(dir)
    send 'it', "passes the Modules 1.0 '#{spec}' test" do
      outcome = []
      env = IncludeJs::Env.new(dir, :globals => {
        :print => lambda { |*args| outcome << args.first }
      })
      env.require('program')
      outcome.join.should_not include 'FAIL'
    end 
  }

end