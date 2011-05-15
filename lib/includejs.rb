module IncludeJs
  require 'v8'
  
  def self.require_root=(root_path)
    @root_path = root_path
  end
    
  def self.require(module_name)
    cxt = V8::Context.new()
    cxt.eval('var exports = {};')
    cxt.load(interpolated_path(module_name))
    cxt['exports']
  end
  
  protected
  def self.interpolated_path(module_name)
    "#{root_path}/#{module_name}.js"
  end
  
  def self.root_path
    @root_path || "#{File.dirname(__FILE__)}/../javascript"
  end
end