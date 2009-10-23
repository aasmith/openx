module OpenX
  module Services
    class Session
      attr_accessor :url, :id
      attr_accessor :user, :password

      def initialize(url)
        @url    = url
        @server = XmlrpcClient.new2("#{@url}")
        @id     = nil
      end

      def create(user, password)
        @user = user
        @password = password
        @id = @server.call('ox.logon', @user, @password)
        self
      end

      def recreate!
        raise "Unable to refresh Session" unless @user && @password
        @id = @server.call('ox.logon', @user, @password)
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
