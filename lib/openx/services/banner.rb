require 'date'

module OpenX
  module Services
    class Banner < Base
      LOCAL_SQL = 'sql'
      LOCAL_WEB = 'web'
      EXTERNAL  = 'url'
      HTML      = 'html'
      TEXT      = 'txt'

      RUNNING = 0
      PAUSED  = 1

      class << self
        def find(id, *args)
          session   = self.connection
          server    = XmlrpcClient.new2("#{session.url}")
          if id == :all
            responses = server.call(find_all(), session, *args)
            response = responses.first
            return [] unless response
            responses = [response]

            ### Annoying..  For some reason OpenX returns a linked list.
            ### Probably a bug....
            while response.key?('aImage')
              response = response.delete('aImage')
              break unless response
              responses << response
            end

            responses.map { |response|
              new(translate(response))
            }
          else
            response  = server.call(find_one(), session, id)
            new(translate(response))
          end
        end
      end

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
                      :backup_image   => :aBackupImage,
                      # 'keyword' only supported by patched server
                      # as per https://developer.openx.org/jira/browse/OX-4779
                      # No averse effect when unsupported by server (returns nil)
                      :keyword        => :keyword

      has_one :campaign

      self.create   = 'ox.addBanner'
      self.update   = 'ox.modifyBanner'
      self.delete   = 'ox.deleteBanner'
      self.find_one = 'ox.getBanner'
      self.find_all = 'ox.getBannerListByCampaignId'

      def initialize(params = {})
        raise ArgumentError.new("Missing campaign_id") unless params[:campaign_id] || params[:campaign]
        params[:campaign_id] ||= params[:campaign].id
        super(params)
      end

      def statistics start_on = Date.today, end_on = Date.today
        session = self.class.connection
        @server.call('ox.bannerDailyStatistics', session, self.id, start_on, end_on)
      end

      def targeting
        session = self.class.connection
        @server.call('ox.getBannerTargeting', session, self.id)
      end

      def targeting= targeting
        session = self.class.connection
        @server.call('ox.setBannerTargeting', session, self.id, targeting)
      end
    end
  end
end
