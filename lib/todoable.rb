require 'rest-client'
require 'json'
require 'todoable/version'
require 'todoable/list'

module Todoable

  class Error < StandardError; end

  class Session
    TOKEN_LIFESPAN = 20 * 60
    AUTHENTICATION_PATH = 'http://todoable.teachable.tech/api/authenticate'

    def initialize(username, password)
      @username = username
      @password = password
      @token = authenticate
    end

    def token_expired?
      Time.now > @token_expiry
    end

    def authenticate
      # make auth call here
      token = RestClient.post(
        AUTHENTICATION_PATH,
        { username: @username, password: @password }.to_json,
        { content_type: :json, accept: :json }
      )

      @token_expiry = Time.now + TOKEN_LIFESPAN
      { 'token': 'fake-token' }
    end

    def make_call(url, params)
      # make api call here

    end
  end

  # session = Todoable::Session.new(username, password)
  # session.authenticate if session.token_expired?

  # Todoable::List.get_all
  # Todoable::List.create(list: { name: 'list name' })
  # Todoable::List.get(:id)
  # Todoable::List.update(:id, { list: { name: 'new name' } })
  # Todoable::List.delete(:id)

  # Todoable::Item.complete(:list_id, :item_id)
  # Todoable::Item.delete(:list_id, :id)
end
