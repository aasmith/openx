require 'xmlrpc/client'

module OpenX

  unless defined? HTTPBroken
    # A module that captures all the possible Net::HTTP exceptions 
    # from http://pastie.org/pastes/145154
    module HTTPBroken; end
    
    [Timeout::Error, Errno::EINVAL, Errno::EPIPE, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, 
      Net::HTTPHeaderSyntaxError, Net::ProtocolError].each {|m| m.send(:include, HTTPBroken)}
  end

  class XmlrpcClient
    @uri = nil
    @server = nil
    
    @@retry_on_http_error = true
    @@timeout = 10 # seconds
    cattr_accessor :retry_on_http_error, :timeout
    
    class << self
      def init_server(uri)
        server = XMLRPC::Client.new2(uri)
        server.timeout = self.timeout
        #server.instance_variable_get(:@http).set_debug_output($stderr)
        server
      end
      protected :init_server
      
      def new2(uri)
        @uri = uri
        @server = init_server(uri)
      end
    end
    
    
    def call(method, *args)
      begin
        @server.call(method, *args)
      rescue HTTPBroken => httpbe
        if self.class.retry_on_http_error
          @server = init_server(uri)
          @server.call(method, *args)
        end
      end
    end
  end
end
