module OpenX
  module Services
    class Advertiser < Base
      attr_accessor :session, :agency

      # Translate our property names to OpenX property names
      @translations = {
        'name'          => 'advertiserName',
        'contact_name'  => 'contactName',
        'email'         => 'emailAddress',
        'username'      => 'username',
        'password'      => 'password',
        'agency_id'     => 'agencyId',
      }
      @translations.each_key { |k| attr_accessor :"#{k}" }
      @endpoint = '/AdvertiserXmlRpcService.php'
      @create   = 'addAdvertiser'
      @update   = 'modifyAdvertiser'
      @delete   = 'deleteAdvertiser'

      def initialize(params = {})
        raise unless params[:agency_id] || params[:agency]
        params[:agency_id] ||= params[:agency].id
        super(params)
      end
    end
  end
end
