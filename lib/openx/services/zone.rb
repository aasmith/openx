module OpenX
  module Services
    class Zone < Base
      BANNER        = 'delivery-b'
      INTERSTITIAL  = 'delivery-i'
      TEXT          = 'delivery-t'
      EMAIL         = 'delivery-e'

      openx_accessor :name          => :zoneName,
                     :id            => :zoneId,
                     :width         => :width,
                     :height        => :height,
                     :type          => :type,
                     :publisher_id  => :publisherId

      has_one :publisher

      self.endpoint = '/ZoneXmlRpcService.php'
      self.create   = 'addZone'
      self.update   = 'modifyZone'
      self.delete   = 'deleteZone'
      self.find_one = 'getZone'
      self.find_all = 'getZoneListByPublisherId'

      def initialize(params = {})
        raise "need publisher" unless params[:publisher_id] || params[:publisher]
        params[:publisher_id] ||= params[:publisher].id
        super(params)
      end
    end
  end
end
