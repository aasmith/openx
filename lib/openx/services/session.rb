module OpenX
  module Services
    class Session
      attr_accessor :url, :id

      @@endpoint = '/LogonXmlRpcService.php'
      def initialize(url)
        @url    = url
        @server = XMLRPC::Client.new2("#{@url}#{@@endpoint}")
        @id     = nil
      end

      def create(user, password)
        @id = @server.call('logon', user, password)
        self
      end

      def destroy
        @server.call('logoff', @id)
        @id = nil
        self
      end
    end
  end
end
