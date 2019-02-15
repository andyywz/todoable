module Todoable
  module Exceptions
    class UserUnauthorized < StandardError
      def initialize(msg = 'You need to authorize your session. (eg: session.authorize)')
        super
      end
    end
  end
end
