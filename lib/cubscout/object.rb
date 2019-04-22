module Cubscout
  # the Object class is the base class for any object retrieved from the Helpscout API.
  # it's attributes can be read either as they are returned (usually camel case)
  # but also in snake case.
  # @example
  #  obj = Cubscout::Object.new("firstName" => "Joren")
  #  puts obj.firstName # => "Joren"
  #  puts obj.first_name # => "Joren"
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

    private

    def camelize(sym)
      parts = sym.to_s.split('_')
      parts[0] + parts[1..-1].map(&:capitalize).join
    end
  end
end
