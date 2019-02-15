module Todoable
  module ListHelper
    BASE_URL = 'http://todoable.teachable.tech/api/lists'.freeze

    def lists
      response = invoke(:get, list_url)

      JSON.parse(response)['lists']
    end

    def get_list(id)
      response = invoke(:get, list_url(id))

      JSON.parse(response)
    end

    def create_list(name)
      response = invoke(:post, list_url, payloadify(name))

      JSON.parse(response)
    end

    def update_list_name(id, name)
      invoke(:patch, list_url(id), payloadify(name))
    end

    def delete_list(id)
      invoke(:delete, list_url(id))
    end

  private
    def payloadify(name)
      { list: { name: name } }
    end

    def list_url(id = nil)
      id ? "#{BASE_URL}/#{id}" : BASE_URL
    end
  end
end
