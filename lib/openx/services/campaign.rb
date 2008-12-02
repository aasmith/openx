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
                      :target_impressions => :target_impressions,
                      :target_clicks  => :target_clicks,
                      :revenue        => :revenue,
                      :revenue_type   => :revenue_type,
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
      self.find_all = 'getCampaignListByAdvertiserId'

      # Revenue types
      CPM             = 1
      CPC             = 2
      CPA             = 3
      MONTHLY_TENANCY = 4

      def initialize(params = {})
        raise ArgumentError unless params[:advertiser_id] || params[:advertiser]
        params[:advertiser_id] ||= params[:advertiser].id
        super(params)
      end
    end
  end
end
