module Cubscout
  module Scopes
    module ClassMethods
      def endpoint(path)
        @path = path
      end

      def path
        @path
      end

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

      def find(id)
        self.new(Cubscout.connection.get("#{path}/#{id}").body)
      end
    end

    def self.included(mod)
      mod.extend ClassMethods
    end
  end
end
