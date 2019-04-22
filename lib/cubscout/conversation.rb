module Cubscout
  # the Conversation class encapsulates a helpscout conversation.
  class Conversation < Object
    endpoint "conversations"

    class << self
      # Get the threads of a conversation. In Helpscout lingo, threads are all
      # the items following a conversation: notes, replies, assignment to users, etc.
      # @param id [Integer] the conversation ID
      # @return [Array<Object>] thread items
      def threads(id)
        Cubscout.connection.get("#{path}/#{id}/threads").body.dig("_embedded", "threads").map { |item| Object.new(item) }
      end

      # Create a note to a conversation.
      # @param id [Integer] the conversation ID
      # @param text [String] the note's text
      # @option attributes [Integer] :user (Resource Owner) ID of the user creating the note.
      # @option attributes [Boolean] :imported (false) The imported field enables thread to be
      #   created for historical purposes (i.e. if moving from a different platform, you can import
      #   your history).
      #   When imported is set to true, no outgoing emails or notifications will be generated.
      # @option attributes [String] :createdAt Optional creation date to be used
      #   when importing conversations and threads.
      #   It can only be used with imported field set to true
      # @option attributes [Array<Hash>] :attachments Optional list of attachments to be attached to this thread
      #     * :fileName (String) Attachment’s file name
      #     * :mimeType (String) Attachment’s mime type
      #     * :data (String) Base64-encoded stream of data.
      # @return [Boolean] success status
      # @example
      #   Cubscout::Conversation.create_note(123, text: "This is a note")
      #   Cubscout::Conversation.create_note(123, text: "This is a note", attachments: [{fileName: "file.txt", mimeType: "plain/text", data: "ZmlsZQ=="}])
      def create_note(id, text:, **attributes)
        Cubscout.connection.post("#{path}/#{id}/notes", attributes.merge(text: text).to_json).body
      end
    end

    # Get the assignee of the conversation
    # @return [User, nil] User assigned to the conversation. Can be nil
    def assignee
      return nil unless self.attributes.has_key?("assignee")
      User.find(self.attributes.dig('assignee', 'id'))
    end

    # Get the threads of the conversation. In Helpscout lingo, threads are all
    # the items following a conversation: notes, replies, assignment to users, etc.
    # @return [Array<Object>] thread items
    def threads
      Conversation.threads(self.id)
    end

    # @option attributes [String] :text the note's text. Required.
    # @option attributes [Integer] :user (Resource Owner) ID of the user creating the note.
    # @option attributes [Boolean] :imported (false) The imported field enables thread to be
    #   created for historical purposes (i.e. if moving from a different platform, you can import
    #   your history).
    #   When imported is set to true, no outgoing emails or notifications will be generated.
    # @option attributes [String] :createdAt Optional creation date to be used
    #   when importing conversations and threads.
    #   It can only be used with imported field set to true
    # @option attributes [Array<Hash>] :attachments Optional list of attachments to be attached to this thread
    #     * :fileName (String) Attachment’s file name
    #     * :mimeType (String) Attachment’s mime type
    #     * :data (String) Base64-encoded stream of data.
    # @return [Boolean] success status
    def create_note(attributes)
      Conversation.create_note(self.id, attributes)
    end
  end
end
