module Todoable
  module ListHelper
    BASE_URL = 'http://todoable.teachable.tech/api/lists'.freeze

    def lists
      response = invoke(:get, BASE_URL)

      JSON.parse(response)['lists']
    end

    def get_list(id)
      response = invoke(:get, "#{BASE_URL}/#{id}")

      JSON.parse(response)
    end

    def create_list(name)
      response = invoke(:post, BASE_URL, payloadify(name))

      JSON.parse(response)
    end

    def update_list_name(id, name)
      invoke(:patch, "#{BASE_URL}/#{id}", payloadify(name))
    end

    def delete_list(id)
      invoke(:delete, "#{BASE_URL}/#{id}")
    end

  private
    def payloadify(name)
      { list: { name: name } }
    end
  end
end
