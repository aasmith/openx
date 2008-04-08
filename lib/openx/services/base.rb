module OpenX
  module Services
    class Base
      class << self
        attr_accessor :endpoint, :translations
        attr_accessor :create, :update, :delete

        def create!(params = {})
          new(params).save!
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
          params[self.class.translations[k]] = value if value
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
