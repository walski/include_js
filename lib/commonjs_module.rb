class CommonJsModule
  def initialize
    @eigenclass = class << self; self; end
  end
  
  def __add_from_js(key, value)
    @eigenclass.send(:define_method, key.to_sym) do |*args|
      value.call(*args)
    end
  end
end