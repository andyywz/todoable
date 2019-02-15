require 'rest-client'
require 'json'
require 'todoable/version'
require 'todoable/list_helper'
require 'todoable/item_helper'
require 'todoable/exceptions'

module Todoable

  class Session
    include Todoable::ListHelper
    include Todoable::ItemHelper
    include Todoable::Exceptions

    attr_accessor :user, :password, :token, :token_expiry

    AUTH_URL = 'http://todoable.teachable.tech/api/authenticate'.freeze

    def initialize(user, password)
      @user = user
      @password = password
    end

    def token_expired?
      Time.now > @token_expiry
    end

    def authenticate
      return @token if @token && !token_expired?

      begin
        response = RestClient::Request.execute(
          method: :post,
          url: AUTH_URL,
          user: @user,
          password: @password,
          headers: {
            content_type: :json,
            accept: :json
          }
        )
        body = JSON.parse(response.body)

        @token_expiry = Time.parse(body['expires_at'])
        @token = body['token']
      rescue RestClient::Unauthorized => e
        # TODO: Log Errors
        raise UserUnauthorized.new('The user and password do not match Todoable Api records')
      end
    end

    def invoke(action, url, payload = {})
      raise UserUnauthorized unless @token

      authenticate if token_expired?

      begin
        response = RestClient::Request.execute(
          method: action,
          url: url,
          payload: payload.to_json,
          headers: {
            Authorization: @token,
            content_type: :json,
            accept: :json
          }
        )

        response.body
      rescue RestClient::UnprocessableEntity => e
        # TODO: Log Errors
        # Re raise for now
        raise
      end
    end
  end
end
