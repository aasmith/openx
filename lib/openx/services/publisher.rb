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
    end
  end
end
