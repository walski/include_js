module IncludeJs
  require 'v8'
      
  def self.require(module_name)
    cxt = V8::Context.new()
    cxt['exports'] = {}
    cxt['require'] = lambda {|m| require(m)}
    cxt.load(interpolated_path(module_name))
    cxt['exports']
  end
  
  def self.root_path=(root_path)
    @root_path = root_path
  end
  
  def self.root_path
    @root_path || File.expand_path('.')
  end
  
  def self.included(clazz)
    clazz.extend(ClassMethods)
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