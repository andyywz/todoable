module Todoable
  module ItemHelper
    BASE_URL = 'http://todoable.teachable.tech/api/lists'.freeze

    def create_item(list_id, name)
      response = invoke(:post, items_url(list_id), { item: { name: name } })

      JSON.parse(response)
    end

    def mark_complete(list_id, item_id)
      invoke(:put, "#{items_url(list_id)}/#{item_id}/finish")
    end

    def delete_item(list_id, item_id)
      invoke(:delete, "#{items_url(list_id)}/#{item_id}")
    end

  private
    def items_url(list_id)
      "#{BASE_URL}/#{list_id}/items"
    end
  end
end
