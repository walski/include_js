module IncludeJs
  require 'v8'  
  
  class << self
    def require(module_id)      
      instance.require(module_id)
    end
    
    def included(clazz)
      clazz.extend(ClassMethods)
    end
    
    def instance
      @instance ||= Env.new
    end
    
    def root_path
      instance.root_path
    end
    
    def root_path=(path)
      instance.root_path = path
    end
    
  end
  
  class Env
    attr_accessor :root_path # FIXME Make this act like a PATH (see Modules 1.1 require.paths) and think about the API
    
    def initialize(root=nil, options = {})
      @root_path = root || File.expand_path('.')
      @globals = options[:globals]
      @modules = {} # This stores all loaded modules by their absolute path (not their id)
    end
    
    def require(module_id)
      load_module(module_id, nil)
    end
    
    private
    
    def load_module(module_id, caller_path=nil)
      path = absolute_path(module_id, caller_path)
      @modules[path] || load(path)
    end
    
    def load(path)
      cxt = V8::Context.new # TODO I have a strong feeling that there should be only one Context for every environment
      @globals.each { |name, value| cxt[name] = value } if @globals
      cxt['require'] = lambda { |module_id| load_module(module_id, path) }
      cxt['exports'] = {}
      exports = @modules[path] = cxt['exports'] # This is to make monkeying with a module work while it gets loaded
      cxt.load(path)
      exports
    end
    
    def absolute_path(module_id, caller_path)
      root = (module_id.start_with?('.') && caller_path) ? File.dirname(caller_path) : @root_path
      File.expand_path("#{root}/#{module_id}.js")
    end
    
  end
  
  protected
  
  module ClassMethods
    def includejs(module_id)
      IncludeJs.require(module_id).each do |name, method|
        define_method name do |*args| 
          method.call(*args)
        end
      end
    end
    
  end
  
end