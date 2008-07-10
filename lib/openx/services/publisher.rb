module OpenX
  module Services
    class Publisher < Base
      openx_accessor :name          => :publisherName,
                     :contact_name  => :contactName,
                     :email         => :emailAddress,
                     :username      => :username,
                     :password      => :password,
                     :id            => :publisherId,
                     :agency_id     => :agencyId

      has_one :agency

      self.endpoint = '/PublisherXmlRpcService.php'
      self.create   = 'addPublisher'
      self.update   = 'modifyPublisher'
      self.delete   = 'deletePublisher'
      self.find_one = 'getPublisher'
      self.find_all = 'getPublisherListByAgencyId'

      def initialize(params = {})
        raise "need agency" unless params[:agency_id] || params[:agency]
        params[:agency_id] ||= params[:agency].id
        super(params)
      end
    end
  end
end
