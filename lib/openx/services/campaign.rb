module OpenX
  module Services
    class Campaign < Base
      # Translate our property names to OpenX property names
      openx_accessor  :name           => :campaignName,
                      :advertiser_id  => :advertiserId,
                      :id             => :campaignId,
                      :start_date     => :startDate,
                      :end_date       => :endDate,
                      :impressions    => :impressions,
                      :clicks         => :clicks,
                      :priority       => :priority,
                      :weight         => :weight

      has_one :advertiser

      self.endpoint = '/CampaignXmlRpcService.php'
      self.create   = 'addCampaign'
      self.update   = 'modifyCampaign'
      self.delete   = 'deleteCampaign'
      self.find_one = 'getCampaign'

      def initialize(params = {})
        raise ArgumentError unless params[:advertiser_id] || params[:advertiser]
        params[:advertiser_id] ||= params[:advertiser].id
        super(params)
      end
    end
  end
end
