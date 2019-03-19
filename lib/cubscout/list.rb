module Cubscout
  class List
    include Enumerable

    class << self
      def path(the_path)
        @path = the_path
      end

      def all(options = {})
        raise "No path given" unless @path

        first_page = new(Cubscout.connection.get(@path, page: options[:page] || 1, **options).body)

        if options[:page]
          first_page.items
        else
          last_page = first_page.number_of_pages

          other_pages = (2..last_page).to_a.map do |page|
            new(Cubscout.connection.get(@path, page: page, **options).body)
          end

          (first_page.items + other_pages.map(&:items)).flatten
        end
      end
    end

    def initialize(raw_payload)
      @raw_payload = raw_payload
    end

    def page
      raw_payload.dig("page", "number")
    end

    def page_size
      raw_payload.dig("page", "size")
    end

    def number_of_pages
      raw_payload.dig("page", "totalPages")
    end

    def size
      raw_payload.dig("page", "totalElements")
    end

    def items
      raw_payload.dig("_embedded", @path)
    end

    def each(&block)
      items.each(&block)
    end

    private

    attr_reader :raw_payload
  end
end
