module OpenX
  module Services
    class Advertiser < Base
      attr_accessor :session, :agency

      openx_accessor :name          => :advertiserName,
                     :contact_name  => :contactName,
                     :email         => :emailAddress,
                     :username      => :username,
                     :password      => :password,
                     :agency_id     => :agencyId,
                     :id            => :advertiserId

      self.endpoint = '/AdvertiserXmlRpcService.php'
      self.create = 'addAdvertiser'
      self.update = 'modifyAdvertiser'
      self.delete = 'deleteAdvertiser'

      def initialize(params = {})
        raise unless params[:agency_id] || params[:agency]
        params[:agency_id] ||= params[:agency].id
        super(params)
      end
    end
  end
end
