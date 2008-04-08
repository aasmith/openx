module OpenX
  module Services
    class Agency
      attr_accessor :session, :id

      # Translate our property names to OpenX property names
      TRANSLATIONS = {
        'name'          => 'agencyName',
        'contact_name'  => 'contactName',
        'email'         => 'emailAddress',
        'username'      => 'username',
        'password'      => 'password',
        'id'            => 'agencyId',
        'account_id'    => 'accountId',
      }
      TRANSLATIONS.each_key { |k| attr_accessor :"#{k}" }
      ENDPOINT = '/AgencyXmlRpcService.php'

      class << self
        def create!(params = {})
          new(params).save!
        end

        def find(session, id)
          server    = XMLRPC::Client.new2("#{session.url}#{ENDPOINT}")
          if id == :all
            response  = server.call('getAgencyList', session.id)
            response.map { |res|
              params    = {}
              TRANSLATIONS.each { |k,v| params[k] = res[v] if res[v] }
              new(params.merge({:session => session}))
            }
          else
            response  = server.call('getAgency', session.id, id)
            params    = {}
            TRANSLATIONS.each { |k,v| params[k] = response[v] if response[v] }
            new(params.merge({:session => session}))
          end
        end

        def destroy(session, id)
          new({:session => session, :id => id }).destroy
        end
      end

      def initialize(params = {})
        raise unless params[:session]
        @id = nil
        params.each { |k,v| send(:"#{k}=", v) }
        @server = XMLRPC::Client.new2("#{session.url}#{ENDPOINT}")
      end

      def new_record?; @id.nil?; end

      def destroy
        @server.call('deleteAgency', session.id, id)
        @id = nil
      end

      def save!
        params = {}
        TRANSLATIONS.keys.each { |k|
          value = send(:"#{k}")
          params[TRANSLATIONS[k]] = value if value
        }
        
        if new_record?
          @id = @server.call('addAgency', session.id, params)
        else
          @server.call('modifyAgency', session.id, params)
        end
        self
      end
    end
  end
end
