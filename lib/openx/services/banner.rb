module OpenX
  module Services
    class Banner < Base
      LOCAL_SQL = 'sql'
      LOCAL_WEB = 'web'
      EXTERNAL  = 'url'
      HTML      = 'html'
      TEXT      = 'txt'

      # Translate our property names to OpenX property names
      openx_accessor  :name           => :bannerName,
                      :campaign_id    => :campaignId,
                      :id             => :bannerId,
                      :storage_type   => :storageType,
                      :file_name      => :fileName,
                      :image_url      => :imageURL,
                      :html_template  => :htmlTemplate,
                      :width          => :width,
                      :height         => :height,
                      :weight         => :weight,
                      :target         => :target,
                      :url            => :url,
                      :status         => :status,
                      :adserver       => :adserver,
                      :transparent    => :transparent,
                      :image          => :aImage,
                      :backup_image   => :aBackupImage

      has_one :campaign

      self.endpoint = '/BannerXmlRpcService.php'
      self.create   = 'addBanner'
      self.update   = 'modifyBanner'
      self.delete   = 'deleteBanner'

      def initialize(params = {})
        raise ArgumentError unless params[:campaign_id] || params[:campaign]
        params[:campaign_id] ||= params[:campaign].id
        super(params)
      end
    end
  end
end
