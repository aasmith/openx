require 'yaml'

module OpenX
  module Services
    class Base
      include Comparable

      CONFIGURATION_YAML = File.join(ENV['HOME'], '.openx', 'credentials.yml')

      class << self
        attr_accessor :endpoint, :translations
        attr_accessor :create, :update, :delete, :find_one, :find_all

        attr_writer :configuration, :connection

        def configuration
          @configuration ||=
            YAML.load_file(CONFIGURATION_YAML)[ENV['OPENX_ENV'] || 'production']
        end

        def connection
          unless( defined?(@connection) && !@connection.nil? )
            @connection = Session.new(configuration['url'])
            @connection.create( configuration['username'],
                                configuration['password']
                              )
          end
          @connection
        end

        def create!(params = {})
          new(params).save!
        end

        def openx_accessor(accessor_map)
          @translations ||= {}
          @translations = accessor_map.merge(@translations)
          accessor_map.each do |ruby,openx|
            attr_accessor :"#{ruby}"
          end
        end

        def has_one(*things)
          things.each do |thing|
            attr_writer :"#{thing}"
            define_method(:"#{thing}") do
              klass = thing.to_s.capitalize.gsub(/_[a-z]/) { |m| m[1].chr.upcase }
              klass = OpenX::Services.const_get(:"#{klass}")
              klass.find(send("#{thing}_id"))
            end
          end
        end

        def find(id, *args)
          session   = Base.connection
          server    = XMLRPC::Client.new2("#{session.url}#{endpoint}")
          if id == :all
            responses = server.call(find_all(), session.id, *args)
            responses.map { |response|
              new(translate(response))
            }
          else
            response  = server.call(find_one(), session.id, id)
            new(translate(response))
          end
        end

        def destroy(id)
          new(:id => id).destroy
        end

        private
        def translate(response)
          params    = {}
          self.translations.each { |k,v|
            params[k] = response[v.to_s] if response[v.to_s]
          }
          params
        end
      end

      def initialize(params = {})
        @id = nil
        params.each { |k,v| send(:"#{k}=", v) }
        @server = XMLRPC::Client.new2("#{Base.connection.url}#{self.class.endpoint}")
        #@server.instance_variable_get(:@http).set_debug_output($stderr)
      end

      def new_record?; @id.nil?; end

      def save!
        params = {}
        session = Base.connection
        self.class.translations.keys.each { |k|
          value = send(:"#{k}")
          params[self.class.translations[k].to_s] = value if value
        }

        if new_record?
          @id = @server.call(self.class.create, session.id, params)
        else
          @server.call(self.class.update, session.id, params)
        end
        self
      end

      def destroy
        session = Base.connection
        @server.call(self.class.delete, session.id, id)
        @id = nil
      end

      def <=>(other)
        self.id <=> other.id
      end
    end
  end
end
