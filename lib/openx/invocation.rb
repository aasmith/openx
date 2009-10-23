module OpenX
  class Invocation
    class << self
      #
      # banner = OpenX::Invocation.view("Plumber")
      #
      # banners = OpenX::Invocation.view("Plumber", :count => 2, :exclude_by_campaignid => true) ;nil
      # banners.each do |banner|
      #   puts "Banner #{banner['bannerid']}"
      # end; nil
      #
      def view(what, params = {})
        defaults = {
          :count => 1,
          :campaignid => 0,
          :target => '',
          :source => '',
          :with_text => false,
          :exclusions => [],
          :inclusions => [],
          :exclude_by_campaignid => false,
          :exclude_by_bannerid => false
        }
        params = defaults.merge(params)
        
        url = OpenX::Services::Base.configuration['invocation_url']

        settings = {:cookies => [], :remote_addr => 'localhost'}
        
        context = [] # used by reference after initial use
        params[:exclusions].each { |item| context << convert_to_context(false, item) }
        params[:inclusions].each { |item| context << convert_to_context(true,  item) }
        count = params[:count].to_i
        
        remote_params = [ what, params[:campaignid], params[:target], params[:source], params[:with_text], context]
        server = XmlrpcClient.new2(url)
        
        out = []
        if count > 0
          (0...count).each do 
            out << banner = server.call('openads.view', settings, *remote_params)
            if count > 1
              if params[:exclude_by_campaignid]
                campaign_id = banner['campaignid']
                context << convert_to_context(false, "campaignid:#{campaign_id}")
              elsif params[:exclude_by_bannerid]
                banner_id = banner['bannerid']
                context << convert_to_context(false, "bannerid:#{banner_id}")
              end
            end
          end
        end
        count > 1 ? out : out.first
      end
      
      def convert_to_context(is_inclusion, item)
        key = is_inclusion ? '==' : '!='
        { key => item }
      end
      protected :convert_to_context
    end
  end
end
