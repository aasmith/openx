module OpenX
  module Services
    class Advertiser < Base

      require 'openx/services/statistics'
      include OpenX::Services::Statistics

      openx_accessor :name          => :advertiserName,
                     :contact_name  => :contactName,
                     :email         => :emailAddress,
                     :username      => :username,
                     :password      => :password,
                     :agency_id     => :agencyId,
                     :id            => :advertiserId

      has_one :agency

      self.create   = 'ox.addAdvertiser'
      self.update   = 'ox.modifyAdvertiser'
      self.delete   = 'ox.deleteAdvertiser'
      self.find_one = 'ox.getAdvertiser'
      self.find_all = 'ox.getAdvertiserListByAgencyId'

      def initialize(params = {})
        raise "need agency" unless params[:agency_id] || params[:agency]
        params[:agency_id] ||= params[:agency].id
        super(params)
      end

      def campaigns
        Campaign.find(:all, self.id)
      end
    end
  end
end
