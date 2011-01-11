module DefJs
  require 'v8'
  require 'json'
  
  def self.included(clazz)
    clazz.extend(ClassMethods)
  end
  
  def v8_context
    self.class.v8_context
  end
  
  def to_js_model
    buffer = "var #{self.class.name} = {\n"
    objects = JSON.parse(to_json).map {|k, v| "  #{k.to_json}: #{v.to_json}"}
    objects += self.class._defjs_function_cores.map do |method_name, core|
      "  #{method_name.to_json}: function#{core}"
    end
    buffer << objects.join(",\n")
    buffer << "\n}"
  end
  
  module ClassMethods
    def v8_context
      @v8_context ||= V8::Context.new
    end
    
    def defjs(method_declaration)
      method_name, *method_body = method_declaration.split("\n")
      parameters = nil
      match = method_name.match(/^[^\(]+$/)
      unless match
        match = method_name.match(/^([^\(]+)\(([^\)]+)\)$/)
        if match
          method_name, parameters = match.captures
          parameters = parameters.split(/,/).map {|p| p.strip}
        end
      end

      raise "Invalid DefJS method head: #{method_name}" unless match
      
      method_name = method_name.strip.to_sym
      
      method_body = method_body.map {|l| "    #{l.strip.chomp}"}.select {|l|l !~ /^\s*$/}.join("\n")
      
      function_core = "(#{parameters ? parameters.join(', ') : ''}) {\n#{method_body}\n  }"
      _defjs_function_cores[method_name] = function_core
      
      v8_context.eval("function #{method_name}#{function_core};")
      
      define_method(method_name) do |*args|
        v8_context.eval("#{method_name}(#{args.map {|e| e.to_json}.join(', ')});")
      end
    end
    
    def _defjs_function_cores
      @_defjs_function_cores ||= {}
    end
  end
end