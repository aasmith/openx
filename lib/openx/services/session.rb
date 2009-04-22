module OpenX
  module Services
    class Session
      attr_accessor :url, :id

      def initialize(url)
        @url    = url
        @server = XMLRPC::Client.new2("#{@url}")
        @id     = nil
      end

      def create(user, password)
        @id = @server.call('ox.logon', user, password)
        self
      end

      def destroy
        @server.call('ox.logoff', @id)
        @id = nil
        self
      end
    end
  end
end
