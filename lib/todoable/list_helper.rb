module Todoable
  module ListHelper
    BASE_URL = 'http://todoable.teachable.tech/api/lists'.freeze

    def get_all
      invoke(:get, BASE_URL)
    end

    def get(id)
      invoke(:get, "#{BASE_URL}/#{id}")
    end

    def create(payload)
      invoke(:post, BASE_URL, payload)
    end

    def update(id, payload)
      invoke(:patch, "#{BASE_URL}/#{id}", payload)
    end

    def delete_list(id)
      invoke(:delete, "#{BASE_URL}/#{id}")
    end
  end
end
