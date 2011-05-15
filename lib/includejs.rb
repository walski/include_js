module IncludeJs
  require 'v8'
  
  def self.require_root=(root_path)
    @root_path = root_path
  end
    
  def self.require(module_name)
    cxt = V8::Context.new()
    cxt.eval('var exports = {};')
    cxt['require'] = lambda {|m| require(m)}
    cxt.load(interpolated_path(module_name))
    cxt['exports']
  end
  
  def self.included(clazz)
    clazz.extend(ClassMethods)
  end
  
  protected
  def self.interpolated_path(module_name)
    "#{root_path}/#{module_name}.js"
  end
  
  def self.root_path
    @root_path || "#{File.dirname(__FILE__)}/../javascript"
  end
  
  module ClassMethods
    def includejs_root(root_path)
      @includejs_root_path = root_path
    end
    
    def includejs(file)
      cxt = V8::Context.new
      cxt['__include_method'] = lambda do |name, method|
        define_method name do |*args|
          method.call(*args)
        end
      end
      
      cxt['__include_obj'] = cxt.load(interpolated_path(file))
      
      cxt.eval('
        for (var key in __include_obj) {
          if (__include_obj.hasOwnProperty(key)) {
            __include_method(key, __include_obj[key]);
          }
        }
      ')
    end
    
    protected
    def interpolated_path(file)
      "#{@includejs_root_path}/#{file}.js"
    end
  end
end