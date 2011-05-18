require 'v8'

module IncludeJS
  @root_path = File.expand_path('.')
  @modules = {} # This stores all loaded modules by their absolute path (not their id)  
  
  class << self
    attr_accessor :root_path # FIXME Make this act like a PATH (see Modules 1.1 require.paths) and think about the API
    
    def require(module_id, globals={})
      load_module(module_id, globals, nil)
    end
    
    def module(module_id)
      result = Module.new
      require(module_id).each do |name, method|
        result.send(:define_method, name) do |*args| 
          method.call(*args)
        end
      end
      result
    end
    
    protected
    
    def load_module(module_id, globals, caller_path)
      path = absolute_path(module_id, caller_path)
      return @modules[path] if @modules[path]
      
      cxt = V8::Context.new # FIXME Maybe we should use only one Context for everything
      globals.each { |name, value| cxt[name] = value }
      cxt['require'] = lambda { |module_id| load_module(module_id, globals, path) }
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
  
end