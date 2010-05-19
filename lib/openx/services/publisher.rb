module OpenX
  module Services
    class Publisher < Base

      require 'openx/services/statistics'
      include OpenX::Services::Statistics

      openx_accessor :name          => :publisherName,
                     :contact_name  => :contactName,
                     :email         => :emailAddress,
                     :username      => :username,
                     :password      => :password,
                     :id            => :publisherId,
                     :agency_id     => :agencyId

      has_one :agency

      self.create   = 'ox.addPublisher'
      self.update   = 'ox.modifyPublisher'
      self.delete   = 'ox.deletePublisher'
      self.find_one = 'ox.getPublisher'
      self.find_all = 'ox.getPublisherListByAgencyId'

      def initialize(params = {})
        raise "need agency" unless params[:agency_id] || params[:agency]
        params[:agency_id] ||= params[:agency].id
        super(params)
      end

      def zones
        Zone.find(:all, self.id)
      end
      
      # Returns statistics in Array of Hashes by day, which are: impression, clicks, requests and revenue.
      def daily_statistics start_on = Date.today, end_on = Date.today, local_time_zone = true
        self.get_statistics('ox.publisherDailyStatistics', start_on, end_on, local_time_zone)
      end

      # Returns statistics in Array of Hashes by banner, which are: impression, clicks, requests and revenue.
      # Also returns bannerName, bannerId, advertiserName, advertiserId, campaignName, campaignId
      def banner_statistics start_on = Date.today, end_on = Date.today, local_time_zone = true
        self.get_statistics('ox.publisherBannerStatistics', start_on, end_on, local_time_zone)
      end
      
    end
  end
end
