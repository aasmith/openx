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

      self.create   = 'ox.addAgency'
      self.update   = 'ox.modifyAgency'
      self.delete   = 'ox.deleteAgency'
      self.find_one = 'ox.getAgency'
      self.find_all = 'ox.getAgencyList'

      def create_advertiser!(params = {})
        Advertiser.create!(params.merge({
          :agency   => self,
        }))
      end

      def advertisers
        Advertiser.find(:all, self.id)
      end

      def publishers
        Publisher.find(:all, self.id)
      end
    end
  end
end
