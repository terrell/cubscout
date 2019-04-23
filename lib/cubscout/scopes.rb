module Cubscout
  # The Scopes module allows for Active Record kind of queries like .all and .find
  # this module is included in Object, meaning that every subclass of Object can
  # call the Scopes ClassMethods.
  # @example
  #  class Foo < Object; end
  #  Foo.find(id)
  #  Foo.all(page: 1)
  module Scopes
    module ClassMethods
      # DSL: necessary to endpoint of the resources to query.
      # @param path [String] path to the endpoint, without leading slash
      # @example
      #   class Conversation
      #     include Cubscout::Scopes
      #     endpoint "conversations"
      #   end
      def endpoint(path)
        @path = path
      end

      # Read the path entered through the DSL
      def path
        @path
      end

      # used with a collection endpoint, get all objects of a certain kind
      # @param options [Hash] Optional query params described in Helspcout API documentation
      # @return [Array<Object>] Returns an array of the class where the method is called.
      #   Example: +Foo.all # => returns Array<Foo>+
      def all(options = {})
        raise "No path given" unless path

        first_page = List.new(Cubscout.connection.get(path, page: options[:page] || 1, **options).body, path, self)

        if options[:page]
          first_page.items
        else
          last_page = first_page.number_of_pages

          other_pages = (2..last_page).to_a.map do |page|
            List.new(Cubscout.connection.get(path, page: page, **options).body, path, self)
          end

          (first_page.items + other_pages.map(&:items)).flatten
        end
      end

      # used with an instance endpoint, get one instance of an Object
      # @param id [Integer] ID of the object to get
      # @return [Object] Returns an instance of the class where the method is called.
      #   Example: +Foo.find(123) # => returns an instance of Foo+
      def find(id)
        self.new(Cubscout.connection.get("#{path}/#{id}").body)
      end
    end

    def self.included(mod)
      mod.extend ClassMethods
    end
  end
end
