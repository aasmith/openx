module OpenX
  module Services
    class Campaign < Base
      attr_accessor :session, :advertiser

      # Translate our property names to OpenX property names
      openx_accessor  :name           => :campaignName,
                      :advertiser_id  => :advertiserId,
                      :start_date     => :startDate,
                      :end_date       => :endDate,
                      :impressions    => :impressions,
                      :clicks         => :clicks,
                      :priority       => :priority,
                      :weight         => :weight

      self.endpoint = '/CampaignXmlRpcService.php'
      self.create   = 'addCampaign'
      self.update   = 'modifyCampaign'
      self.delete   = 'deleteCampaign'

      def initialize(params = {})
        raise ArgumentError unless params[:advertiser_id] || params[:advertiser]
        params[:advertiser_id] ||= params[:advertiser].id
        super(params)
      end
    end
  end
end
