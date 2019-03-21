module Cubscout
  class Conversation < Object
    path "conversations"

    class << self
      def threads(id)
        Cubscout.connection.get("#{read_path}/#{id}/threads").body.dig("_embedded", "threads").map { |item| Object.new(item) }
      end

      def create_note(id, attributes)
        raise "Missing attribute `text` while creating new note" unless attributes.has_key?(:text)
        Cubscout.connection.post("#{read_path}/#{id}/notes", attributes.to_json)
      end
    end

    def threads
      Conversation.threads(self.id)
    end

    def create_note(attributes)
      Conversation.create_note(self.id, attributes)
    end
  end
end
