module IncludeJs
  require 'v8'
  
  @root_path = File.expand_path('.')
  @modules = {}
     
  class << self   
    attr_accessor :root_path
    
    def require(module_name, caller_path=nil) # FIXME Second argument is not supposed to be called form Ruby   
      path = absolute_path(module_name, caller_path)
      @modules[path] || load_module(path)
    end
  
    def included(clazz)
      clazz.extend(ClassMethods)
    end
  end
  
  protected
  
  def self.load_module(path)
    cxt = V8::Context.new
    cxt['print'] = lambda {|*args| puts(args) } # FIXME Only used in testing
    cxt['require'] = lambda {|module_name|
      require(module_name, path)
    }
    cxt['exports'] = {}
    # Mark as loading and make accesible to write stuff during evaluation
    @modules[path] = cxt['exports']
    cxt.load(path)
    cxt['exports']
  end
  
  def self.absolute_path(module_name, caller_path)
    root = (module_name.start_with?('.') && caller_path) ? File.dirname(caller_path) : root_path
    File.expand_path("#{root}/#{module_name}.js")
  end
  
  module ClassMethods    
    def includejs(module_name)
      IncludeJs.require(module_name).each do |name, method|
        define_method name do |*args| 
          method.call(*args)
        end
      end
    end
  end
  
end