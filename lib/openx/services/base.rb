module OpenX
  module Services
    class Base
      class << self
        attr_accessor :endpoint, :translations
        attr_accessor :create, :update, :delete, :find_one, :find_all

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

        def find(session, id, *args)
          server    = XMLRPC::Client.new2("#{session.url}#{endpoint}")
          if id == :all
            responses = server.call(find_all(), session.id, *args)
            responses.map { |response|
              new(translate(response).merge({:session => session}))
            }
          else
            response  = server.call(find_one(), session.id, id)
            new(translate(response).merge({:session => session}))
          end
        end

        def destroy(session, id)
          new({:session => session, :id => id }).destroy
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
        raise unless params[:session]
        @id = nil
        params.each { |k,v| send(:"#{k}=", v) }
        @server = XMLRPC::Client.new2("#{session.url}#{self.class.endpoint}")
      end

      def new_record?; @id.nil?; end

      def save!
        params = {}
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
        @server.call(self.class.delete, session.id, id)
        @id = nil
      end
    end
  end
end
