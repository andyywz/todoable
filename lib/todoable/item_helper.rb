module Todoable
  module ItemHelper
    BASE_URL = 'http://todoable.teachable.tech/api/lists'.freeze

    def create_item(list_id, payload)
      invoke(:post, "#{BASE_URL}/#{list_id}/items", payload)
    end

    def complete(list_id, item_id, payload)
      invoke(:put, "#{BASE_URL}/#{list_id}/items/#{item_id}/finish", payload)
    end

    def delete_item(list_id, item_id)
      invoke(:delete, "#{BASE_URL}/#{list_id}/items/#{item_id}")
    end
  end
end
