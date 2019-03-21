module Cubscout
  class Object
    include Scopes

    def initialize(attributes)
      @attributes = attributes
    end

    def method_missing(method_name, *args, &block)
      key = camelize(method_name)
      return super unless @attributes.key?(key)

      @attributes[key]
    end

    def underscore(string)
      string.gsub(/[A-Z]/) { "_#{$&.downcase}" }
    end

    def camelize(sym)
      parts = sym.to_s.split('_')
      parts[0] + parts[1..-1].map(&:capitalize).join
    end
  end
end
