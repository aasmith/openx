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
    
    @retry_on_http_error = true
    @timeout = 10 # seconds
    
    class << self
      attr_accessor :retry_on_http_error, :timeout
      
      def init_server(uri)
        server = XMLRPC::Client.new2(uri)
        server.timeout = self.timeout
        #server.instance_variable_get(:@http).set_debug_output($stderr)
        server
      end
      
      def new2(uri)
        server = init_server(uri)
        new(server, uri)
      end
    end
    
    def initialize(server, uri)
      @server = server
      @uri = uri
    end
    
    def call(method, *args)
      if args.first.is_a?(OpenX::Services::Session)
        session = args.shift()
        args.unshift(session.id)
        begin
          do_call(method, *args)
        rescue XMLRPC::FaultException => sess_id_err
          if sess_id_err.message.strip == 'Session ID is invalid'
            session.recreate!
            args.shift()
            args.unshift(session.id)
            do_call(method, *args)
          else
            raise sess_id_err
          end
        end
      else
        do_call(method, *args)
      end
    end
    
    def do_call(method, *args)
      begin
        @server.call(method, *args)
      rescue HTTPBroken => httpbe
        if self.class.retry_on_http_error
          @server = self.class.init_server(@uri)
          @server.call(method, *args)
        else
          raise httpbe
        end
      end
    end
    private :do_call
    
  end
end
