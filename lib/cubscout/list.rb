module Cubscout
  class List
    include Enumerable

    def initialize(raw_payload, collection_name, object_class)
      @raw_payload = raw_payload
      @collection_name = collection_name
      @object_class = object_class
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
      Array(raw_payload.dig("_embedded", collection_name)).map { |item| object_class.new(item) }
    end

    def each(&block)
      items.each(&block)
    end

    private

    attr_reader :raw_payload, :collection_name, :object_class
  end
end
