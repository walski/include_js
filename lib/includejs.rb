module IncludeJs
  require 'v8'
  
  @root_path = File.expand_path('.')
     
  class << self   
    attr_accessor :root_path
    
    def require(module_name)
      cxt = V8::Context.new()
      cxt['exports'] = {}
      cxt['require'] = lambda {|m| require(m)}
      cxt.load(interpolated_path(module_name))
      cxt['exports']
    end
  
    def included(clazz)
      clazz.extend(ClassMethods)
    end
  end
  
  protected
  def self.interpolated_path(module_name)
    "#{root_path}/#{module_name}.js"
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