require 'rest-client'
require 'json'
require 'todoable/version'
require 'todoable/list_helper'
require 'todoable/item_helper'

module Todoable

  class Error < StandardError; end
  class UnauthorizedError < StandardError; end

  class Session
    include Todoable::ListHelper
    include Todoable::ItemHelper

    TOKEN_LIFESPAN = 20 * 60
    AUTH_URL = 'http://todoable.teachable.tech/api/authenticate'

    def initialize(username, password)
      @username = username
      @password = password
      @token = nil

      authenticate
    end

    def token_expired?
      Time.now > @token_expiry
    end

    def authenticate
      return @token if @token && !token_expired?

      begin
        payload = { username: @username, password: @password }.to_json
        headers = { content_type: :json, accept: :json }

        response = RestClient.post(AUTH_URL, payload, headers)

        @token_expiry = Time.now + TOKEN_LIFESPAN
        @token = JSON.parse(response.body)['token']
      rescue RestClient::Unauthorized
        # Log Error
        puts 'the username and password combination does not match our records'
        @token = nil
      end

      @token
    end

    def invoke(method, url, payload = {})
      authenticate

      begin
        response = RestClient::Request.execute(
          method: method,
          url: url,
          payload: payload,
          headers: {
            Authorization: @token,
            content_type: :json,
            accept: :json
          }
        )

        result = JSON.parse(response.body)
      rescue RestClient::UnprocessableEntity
        # Log Error
        # TODO: Error handling
        result = nil # return a proper error message
      end

      result
    end
  end

  # session = Todoable::Session.new(username, password)

  # session.get_all
  # session.create_list(list: { name: 'list name' })
  # session.get(:id)
  # session.update(:id, { list: { name: 'new name' } })
  # session.delete_list(:id)

  # session.create_item(:list_id, payload)
  # session.complete(:list_id, :item_id)
  # session.delete_item(:list_id, :id)
end
