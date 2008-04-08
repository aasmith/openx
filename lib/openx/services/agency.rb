module OpenX
  module Services
    class Agency < Base
      attr_accessor :session

      # Translate our property names to OpenX property names
      @translations = {
        'name'          => 'agencyName',
        'contact_name'  => 'contactName',
        'email'         => 'emailAddress',
        'username'      => 'username',
        'password'      => 'password',
        'id'            => 'agencyId',
        'account_id'    => 'accountId',
      }
      @translations.each_key { |k| attr_accessor :"#{k}" }

      @endpoint = '/AgencyXmlRpcService.php'
      @create   = 'addAgency'
      @update   = 'modifyAgency'
      @delete   = 'deleteAgency'

      class << self
        def find(session, id)
          server    = XMLRPC::Client.new2("#{session.url}#{endpoint}")
          if id == :all
            response  = server.call('getAgencyList', session.id)
            response.map { |res|
              params    = {}
              @translations.each { |k,v| params[k] = res[v] if res[v] }
              new(params.merge({:session => session}))
            }
          else
            response  = server.call('getAgency', session.id, id)
            params    = {}
            @translations.each { |k,v| params[k] = response[v] if response[v] }
            new(params.merge({:session => session}))
          end
        end

        def destroy(session, id)
          new({:session => session, :id => id }).destroy
        end
      end

      def create_advertiser!(params = {})
        Advertiser.create!(params.merge({
          :agency   => self,
          :session  => session
        }))
      end
    end
  end
end
