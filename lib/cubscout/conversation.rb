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

      # Update a conversation.
      # @param id [Integer] the conversation ID
      # @param op [String] Patch operation to be carried out, one of +move+, +remove+, +replace+
      # @param path [String] Path of the value to be changed, one of:
      #   +/assignTo+, +/draft+, +/mailboxId+, +/primaryCustomer.id+, +/status+, +/subject+
      # @option attributes [Varies] :value Value to be used in operation, refer to this documentation
      #   for valid types: https://developer.helpscout.com/mailbox-api/endpoints/conversations/update/#valid-paths-and-operations.
      #   In case of status update +(op: "replace", path: "/status")+, :value must be one of +active+, +closed+, +open+, +pending+, +spam+
      def update(id, op:, path:, **attributes)
        Cubscout.connection.patch("#{Conversation.path}/#{id}", attributes.merge(op: op, path: path).to_json).body
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

    # Create a note to a conversation.
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

    # Update a conversation.
    # @option attributes [String] :op Patch operation to be carried out, one of +move+, +remove+, +replace+. Required
    # @option attributes [String] :path Path of the value to be changed, one of:
    #   +/assignTo+, +/draft+, +/mailboxId+, +/primaryCustomer.id+, +/status+, +/subject+. Required
    # @option attributes [Varies] :value Value to be used in operation, refer to this documentation
    #   for valid types: https://developer.helpscout.com/mailbox-api/endpoints/conversations/update/#valid-paths-and-operations.
    #   In case of status update +(op: "replace", path: "/status")+, :value must be one of +active+, +closed+, +open+, +pending+, +spam+
    def update(**options)
      Conversation.update(self.id, op: options[:op], path: options[:path])
    end
  end
end
