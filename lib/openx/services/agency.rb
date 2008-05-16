module OpenX
  module Services
    class Agency < Base
      attr_accessor :session

      # Translate our property names to OpenX property names
      openx_accessor  :name          => :agencyName,
                      :contact_name  => :contactName,
                      :email         => :emailAddress,
                      :username      => :username,
                      :password      => :password,
                      :id            => :agencyId,
                      :account_id    => :accountId

      self.endpoint = '/AgencyXmlRpcService.php'
      self.create   = 'addAgency'
      self.update   = 'modifyAgency'
      self.delete   = 'deleteAgency'

      class << self
        def find(session, id)
          server    = XMLRPC::Client.new2("#{session.url}#{endpoint}")
          if id == :all
            responses = server.call('getAgencyList', session.id)
            responses.map { |response|
              new(translate(response).merge({:session => session}))
            }
          else
            response  = server.call('getAgency', session.id, id)
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

      def create_advertiser!(params = {})
        Advertiser.create!(params.merge({
          :agency   => self,
          :session  => session
        }))
      end
    end
  end
end
