module Cubscout
  class Object
    include Scopes

    attr_reader :attributes

    def initialize(attributes)
      # Dirty deep_transform_keys to strings
      @attributes = JSON.parse(attributes.to_json)
    end

    def method_missing(method_name, *args, &block)
      key = camelize(method_name)
      return super unless @attributes.key?(key)

      @attributes[key]
    end

    def camelize(sym)
      parts = sym.to_s.split('_')
      parts[0] + parts[1..-1].map(&:capitalize).join
    end
  end
end
