module IncludeJs
  require 'v8'
  require 'commonjs_module'
  
  def self.require_root=(root_path)
    @root_path = root_path
  end
    
  def self.require(module_name)
    cxt = V8::Context.new()
    cxt.eval('var exports = {};')
    cxt.load(interpolated_path(module_name))

    extract_exports(cxt)
  end
  
  protected
  def self.extract_exports(cxt)
    common_js_module = CommonJsModule.new
    cxt['__module'] = common_js_module
    cxt.eval(
      'for (var key in exports) {
          if (exports.hasOwnProperty(key)) {
            __module.__add_from_js(key, exports[key]);
          }
      }'
    )
    common_js_module
  end
  
  def self.interpolated_path(module_name)
    "#{root_path}/#{module_name}.js"
  end
  
  def self.root_path
    @root_path || "#{File.dirname(__FILE__)}/../javascript"
  end
end