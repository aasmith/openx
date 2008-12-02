module OpenX
  module Services
    class Agency < Base
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
      self.find_one = 'getAgency'
      self.find_all = 'getAgencyList'

      def create_advertiser!(params = {})
        Advertiser.create!(params.merge({
          :agency   => self,
        }))
      end

      def advertisers
        Advertiser.find(:all, self.id)
      end
    end
  end
end
