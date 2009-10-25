require 'yaml'

module OpenX
  module Services
    class Base
      include Comparable

      CONFIGURATION_YAML = File.join(ENV['HOME'], '.openx', 'credentials.yml')

      @@connection    = nil
      @@configuration = nil

      class << self
        attr_accessor :translations
        attr_accessor :create, :update, :delete, :find_one, :find_all

        def configuration
          @@configuration ||=
            YAML.load_file(CONFIGURATION_YAML)[ENV['OPENX_ENV'] || 'production']
        end

        def configuration=(c); @@configuration = c; end

        def connection= c
          @@connection = c
        end

        def connection
          unless @@connection
            @@connection = Session.new(configuration['url'])
            @@connection.create( configuration['username'],
                                configuration['password']
                              )
          end
          @@connection
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
          session   = self.connection
          server    = XmlrpcClient.new2("#{session.url}")
          if id == :all
            responses = server.call(find_all(), session, *args)
            responses.map { |response|
              new(translate(response))
            }
          else
            response  = server.call(find_one(), session, id)
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
        @server = XmlrpcClient.new2("#{self.class.connection.url}")
      end

      def new_record?; @id.nil?; end

      def save!
        params = {}
        session = self.class.connection
        self.class.translations.keys.each { |k|
          value = send(:"#{k}")
          params[self.class.translations[k].to_s] = value if value
        }

        if new_record?
          @id = @server.call(self.class.create, session, params)
        else
          @server.call(self.class.update, session, params)
        end
        self
      end

      def destroy
        session = self.class.connection
        @server.call(self.class.delete, session, id)
        @id = nil
      end

      def <=>(other)
        self.id <=> other.id
      end
    end
  end
end
