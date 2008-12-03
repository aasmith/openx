require 'date'

module OpenX
  module Services
    class Banner < Base
      LOCAL_SQL = 'sql'
      LOCAL_WEB = 'web'
      EXTERNAL  = 'url'
      HTML      = 'html'
      TEXT      = 'txt'

      class << self
        def find(id, *args)
          session   = self.connection
          server    = XMLRPC::Client.new2("#{session.url}#{endpoint}")
          if id == :all
            responses = server.call(find_all(), session.id, *args)
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
            response  = server.call(find_one(), session.id, id)
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
                      :backup_image   => :aBackupImage

      has_one :campaign

      self.endpoint = '/BannerXmlRpcService.php'
      self.create   = 'addBanner'
      self.update   = 'modifyBanner'
      self.delete   = 'deleteBanner'
      self.find_one = 'getBanner'
      self.find_all = 'getBannerListByCampaignId'

      def initialize(params = {})
        raise ArgumentError unless params[:campaign_id] || params[:campaign]
        params[:campaign_id] ||= params[:campaign].id
        super(params)
      end

      def statistics start_on = Date.today - 1, end_on = Date.today + 1
        session = self.class.connection
        @server.call('bannerDailyStatistics', session.id, self.id, start_on, end_on)
      end
    end
  end
end
